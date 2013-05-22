module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  #
  # This module contains the class-level methods used by Artoo::Robot
  class Robot
    module ClassMethods
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

        setup_interrupt

        unless cli?
          start_api
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

      def setup_interrupt
        Signal.trap("INT") do
          master.stop_work if master
        end
      end

      def start_api
        Celluloid::Actor[:api] = Api.new(self.api_host, self.api_port) if self.use_api
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
  end
end
