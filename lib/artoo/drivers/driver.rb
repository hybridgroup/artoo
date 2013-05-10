module Artoo
  module Drivers
    # The Driver class is the base class used to
    # implement behavior for a specific kind of hardware devices. Examples
    # would be an Arduino, a Sphero, or an ARDrone.
    #
    # Derive a class from this class, in order to implement behavior
    # for a new type of hardware device.
    class Driver
      include Celluloid
      include Celluloid::Notifications

      attr_reader :parent

      COMMANDS = [].freeze

      # Create new driver
      # @param [Hash] params
      # @option params [Object] :parent
      def initialize(params={})
        @parent = params[:parent]
      end

      # @return [Connection] parent connection
      def connection
        parent.connection
      end

      # @return [String] parent pin
      def pin
        parent.pin
      end

      # @return [String] parent interval
      def interval
        parent.interval
      end

      # Generic driver start
      def start_driver
        Logger.info "Starting driver '#{self.class.name}'..."
      end

      # @return [String] parent topic name
      def event_topic_name(event)
        parent.event_topic_name(event)
      end

      # @return [Collection] commands
      def commands
        self.class.const_get('COMMANDS')
      end

      # Execute command
      # @param [Symbol] method_name
      # @param [Array]  arguments
      def command(method_name, *arguments)
        known_command?(method_name)
        if arguments.first
          self.send(method_name, *arguments)
        else
          self.send(method_name)
        end
      rescue Exception => e
        Logger.error e.message
        Logger.error e.backtrace.inspect
        return nil
      end

      # @return [Boolean] True if command exists
      def known_command?(method_name)
        return true if commands.include?(method_name.intern)

        Logger.warn("Calling unknown command '#{method_name}'...")
        return false
      end

      # Sends missing methods to connection
      def method_missing(method_name, *arguments, &block)
        connection.send(method_name, *arguments, &block)
      rescue Exception => e
        Logger.error e.message
        Logger.error e.backtrace.inspect
        return nil
      end
    end
  end
end
