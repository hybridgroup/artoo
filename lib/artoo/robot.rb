require 'celluloid/autostart'
require 'celluloid/io'
require 'multi_json'
require 'artoo/ext/timers'
require 'artoo/ext/actor'

require 'artoo/basic'
require 'artoo/connection'
require 'artoo/device'
require 'artoo/events'
require 'artoo/api'
require 'artoo/master'
require 'artoo/port'
require 'artoo/utility'


module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  class Robot
    include Celluloid
    include Celluloid::Notifications
    extend Artoo::Basic
    include Artoo::Utility
    include Artoo::Events

    attr_reader :connections, :devices, :name

    # Create new robot
    # @param [Hash] params
    # @option params [String]     :name
    # @option params [Collection] :connections
    # @option params [Collection] :devices
    def initialize(params={})
      @name = params[:name] || "Robot #{random_string}"
      initialize_connections(params[:connections] || {})
      initialize_devices(params[:devices] || {})
    end

    class << self
      attr_accessor :device_types, :working_code,
                    :use_api, :api_host, :api_port

      def connection_types
        @@connection_types ||= []
      end

      # Connection to some hardware that has one or more devices via some specific protocol
      # @example connection :arduino, :adaptor => :firmata, :port => '/dev/tty.usbmodemxxxxx'
      # @param [String] name
      # @param [Hash]   params
      def connection(name, params = {})
        Celluloid::Logger.info "Registering connection '#{name}'..."
        self.connection_types << {:name => name}.merge(params)
      end

      # Device that uses a connection to communicate
      # @example device :collision_detect, :driver => :switch, :pin => 3
      # @param [String] name
      # @param [Hash]   params
      def device(name, params = {})
        Celluloid::Logger.info "Registering device '#{name}'..."
        self.device_types ||= []
        self.device_types << {:name => name}.merge(params)
      end

      # The work that needs to be performed
      # @example
      #   work do
      #     every(10.seconds) do
      #       puts "hello, world"
      #     end
      #   end
      # @param [block] work
      def work(&block)
        Celluloid::Logger.info "Preparing work..."
        self.working_code = block if block_given?
      end

      # Activate RESTful api
      # Example:
      #   api :host => '127.0.0.1', :port => '1234'
      def api(params = {})
        Celluloid::Logger.info "Registering api..."
        self.use_api = true
        self.api_host = params[:host] || '127.0.0.1'
        self.api_port = params[:port] || '4321'
      end

      # Work can be performed by either:
      #  an existing instance
      #  an array of existing instances
      #  or, a new instance can be created
      # @param [Robot] robot
      def work!(robot=nil)
        return if is_running?
        prepare_robots(robot)

        Signal.trap("INT") do
          master.stop_work if master
        end

        unless cli?
          Celluloid::Actor[:api] = Api.new(self.api_host, self.api_port) if self.use_api
          master.start_work
          sleep # sleep main thread, and let the work commence!
        end
      end

      # Prepare master robots for work
      def prepare_robots(robot=nil)
        if robot.respond_to?(:work)
          robots = [robot]
        elsif robot.kind_of?(Array)
          robots = robot
        else
          robots = [self.new]
        end

        Celluloid::Actor[:master] = Master.new(robots)
      end

      # Master actor
      def master
        Celluloid::Actor[:master]
      end

      # @return [Boolean] True if test env
      def test?
        ENV["ARTOO_TEST"] == 'true'
      end

      # @return [Boolean] True if cli env
      def cli?
        ENV["ARTOO_CLI"] == 'true'
      end

      # @return [Boolean] True if it's running
      def is_running?
        @@running ||= false
        @@running == true
      end

      def running!
        @@running = true
      end

      def stopped!
        @@running = false
      end
    end

    # @return [String] Name without spaces and downcased
    def safe_name
      name.gsub(' ', '_').downcase
    end

    # @return [String] Api Host
    def api_host
      self.class.api_host
    end

    # @return [String] Api Port
    def api_port
      self.class.api_port
    end

    # start doing the work
    def work
      Logger.info "Starting work..."
      execute_startup(connections) {|c| c.future.connect}
      execute_startup(devices) {|d| d.future.start_device}
      execute_working_code
    end

    # pause the work
    def pause_work
      Logger.info "Pausing work..."
      current_instance.timers.pause
    end

    # continue with the work
    def continue_work
      Logger.info "Continuing work..."
      current_instance.timers.continue
    end

    # Terminate all connections
    def disconnect
      connections.each {|k, c| c.async.disconnect}
    end

    # @return [Connection] default connection
    def default_connection
      connections.values.first
    end

    # @return [Collection] connection types
    def connection_types
      current_class.connection_types
    end

    # @return [Collection] device types
    def device_types
      current_class.device_types ||= []
      current_class.device_types
    end

    # @return [Proc] current working code
    def working_code
      current_class.working_code ||= proc {puts "No work defined."}
    end

    # @param [Symbol] period
    # @param [Numeric] interval
    # @return [Boolean] True if there is recurring work for the period and interval
    def has_work?(period, interval)
      current_instance.timers.find {|t| t.recurring == (period == :every) && t.interval == interval}
    end

    # @return [Hash] robot
    def to_hash
      {
        :name => name,
        :connections => connections.each_value.collect {|c|c.to_hash},
        :devices => devices.each_value.collect {|d|d.to_hash}
      }
    end

    # @return [JSON] robot
    def as_json
      MultiJson.dump(to_hash)
    end

    # @return [String] robot
    def inspect
      "#<Robot #{object_id}>"
    end

    private

    def initialize_connections(params={})
      @connections = {}
      connection_types.each {|ct|
        Logger.info "Initializing connection #{ct[:name].to_s}..."
        cp = params[ct[:name]] || {}
        c = Connection.new(ct.merge(cp).merge(:parent => current_instance))
        @connections[ct[:name]] = c
      }
    end

    def initialize_devices(params={})
      @devices = {}
      device_types.each {|d|
        Logger.info "Initializing device #{d[:name].to_s}..."
        d = Device.new(d.merge(:parent => current_instance))
        instance_eval("def #{d.name}; return devices[:#{d.name}]; end")
        @devices[d.name.intern] = d
      }
    end

    def execute_startup(things, &block)
      future_things = things.each_value.collect {|t| yield(t)}
      future_things.each {|v| result = v.value}
    end

    def execute_working_code
      current_instance.instance_eval(&working_code)
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
    end
  end
end
