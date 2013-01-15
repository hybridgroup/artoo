require 'artoo/connector/connect'

module Artoo
  module Connector
    # The Sphero class is the subclass of the Connect class that represents   
    # how to connect to a Sphero (http://gosphero.com)
    class Sphero < Connect
      RETRY_COUNT = 5
      attr_reader :sphero

      def initialize(params={})
        super
      end

      def finalize
        sphero.close if sphero
      end

      def connect
        @retries_left = RETRY_COUNT
        require 'sphero'
        begin
          @sphero = ::Sphero.new port
          super
          return true
        rescue Errno::EBUSY => e
          @retries_left = @retries_left - 1
          if @retries_left > 0
            retry
          else
            raise e  
          end
        end
      end

      def disconnect
        sphero.close
        super
      end
    end
  end
end