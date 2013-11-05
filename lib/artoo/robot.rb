require 'celluloid/autostart'
require 'celluloid/io'
require 'multi_json'
require 'artoo/ext/timers'
require 'artoo/ext/actor'

require 'artoo/robot_class_methods'
require 'artoo/basic'
require 'artoo/connection'
require 'artoo/adaptors/adaptor'
require 'artoo/device'
require 'artoo/drivers/driver'
require 'artoo/events'
require 'artoo/exceptions'
require 'artoo/api/api'
require 'artoo/master'
require 'artoo/port'
require 'artoo/utility'

module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  #
  # This file contains the instance-level methods used by Artoo::Robot
  class Robot
    include Celluloid
    include Celluloid::Notifications
    extend Artoo::Basic
    extend Artoo::Robot::ClassMethods
    include Artoo::Utility
    include Artoo::Events

    attr_reader :connections, :devices, :name

    exclusive :execute_startup

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
      current_class.connection_types ||= [{:name => :passthru}]
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
        dp = params[d[:name]] || {}
        d = Device.new(d.merge(dp).merge(:parent => current_instance))
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
