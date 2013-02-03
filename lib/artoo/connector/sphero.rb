require 'artoo/connector/connect'

module Artoo
  module Connector
    # Connect to a Sphero (http://gosphero.com)
    class Sphero < Connect
      RETRY_COUNT = 5
      attr_reader :sphero

      def finalize
        if connected?
          sphero.stop
          sphero.close
        end
      end

      def connect
        @retries_left = RETRY_COUNT
        require 'sphero' unless defined?(::Sphero)
        begin
          @sphero = ::Sphero.new port
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

      def disconnect
        sphero.close
        super
      end

      def method_missing(method_name, *arguments, &block)
        sphero.send(method_name, *arguments, &block)
      end
    end
  end
end