require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Sphero (http://gosphero.com)
    class Sphero < Adaptor
      RETRY_COUNT = 5
      attr_reader :sphero

      def finalize
        if connected?
          sphero.close
        end
      end

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