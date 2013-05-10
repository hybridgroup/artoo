require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Sphero device
    # @see http://gosphero.com Sphero information
    # @see http://rubydoc.info/gems/hybridgroup-sphero HybridGroup Sphero Documentation
    class Sphero < Adaptor
      finalizer :finalize
      attr_reader :sphero

      # Number of retries when connecting
      RETRY_COUNT = 5

      # Closes connection with device if connected
      # @return [Boolean]
      def finalize
        if connected?
          sphero.close
        end
      end

      # Creates a connection with Sphero object with retries
      # @return [Boolean]
      def connect
        @retries_left = RETRY_COUNT
        require 'sphero' unless defined?(::Sphero)
        begin
          @sphero = ::Sphero.new(connect_to)
          super
          return true
        rescue Errno::EBUSY => e
          @retries_left -= 1
          if @retries_left > 0
            retry
          else
            Logger.error e.message
            Logger.error e.backtrace.inspect
            return false
          end
        end
      end

      # Closes connection with device
      # @return [Boolean]
      def disconnect
        sphero.close
        super
      end

      # Uses method missing to call sphero actions
      # @see http://rubydoc.info/gems/hybridgroup-sphero/Sphero Sphero documentation
      def method_missing(method_name, *arguments, &block)
        sphero.send(method_name, *arguments, &block)
      end
    end
  end
end
