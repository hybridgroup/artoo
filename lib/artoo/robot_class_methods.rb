module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  #
  # This module contains the class-level methods used by Artoo::Robot
  class Robot
    class << self; attr_accessor :connection_types, :device_types; end

    module ClassMethods
      attr_accessor :working_code, :use_api, :api_host, :api_port

      # Connection to some hardware that has one or more devices via some specific protocol
      # @example connection :arduino, :adaptor => :firmata, :port => '/dev/tty.usbmodemxxxxx'
      # @param [String] name
      # @param [Hash]   params
      def connection(name, params = {})
        @connection_types ||= []
        Celluloid::Logger.info "Registering connection '#{name}'..."
        @connection_types << {:name => name}.merge(params)
      end

      # Device that uses a connection to communicate
      # @example device :collision_detect, :driver => :switch, :pin => 3
      # @param [String] name
      # @param [Hash]   params
      def device(name, params = {})
        @device_types ||= []
        Celluloid::Logger.info "Registering device '#{name}'..."
        @device_types << {:name => name}.merge(params)
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
        prepare_work(robot)
        return if is_running?

        unless cli?
          begin
            start_api
            Artoo::Master.start_work
            begin_working
          rescue Interrupt
            Celluloid::Logger.info 'Shutting down...'
            Artoo::Master.stop_work
            # Explicitly exit so busy Processor threads can't block
            # process shutdown... taken from Sidekiq, thanks!
            exit(0)
          end
        end
      end

      # Prepare master robots for work
      def prepare_work(robot=nil)
        if robot.respond_to?(:work)
          robots = [robot]
        elsif robot.kind_of?(Array)
          robots = robot
        else
          robots = [self.new]
        end

        Artoo::Master.assign(robots)
      end

      def begin_working
        self_read, self_write = IO.pipe
        setup_interrupt(self_write)
        handle_signals(self_read)
      end
      
      def setup_interrupt(self_write)
        Signal.trap("INT") do
          self_write.puts("INT")
        end
      end

      def handle_signals(self_read)
        while readable_io = IO.select([self_read])
          signal = readable_io.first[0].gets.strip
          raise Interrupt
        end
      end

      def start_api
        Celluloid::Actor[:api] = Api::Server.new(self.api_host, self.api_port) if self.use_api
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
