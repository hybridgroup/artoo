require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Roomba (http://www.irobot.com/en/us/robots/Educators/Create.aspx)
    class Roomba < Adaptor
      
      attr_reader :sp

      def finalize
        if connected?
          @sp.close
        end
      end

      def connect
        if port.is_serial?
          @sp = connect_to_serial
          @sp.dtr = 0
          @sp.rts = 0
        else
          @sp = connect_to_tcp
        end
        super
      end
      
      def send_bytes(bytes)
        bytes = [bytes] unless bytes.respond_to?(:map)
        bytes.map!(&:chr)
        Logger.debug "sending: #{bytes.inspect}"
        res = []
        bytes.each{|b| res << @sp.write(b) }
        Logger.debug "returned: #{res.inspect}"
      end

      def disconnect
        @sp.close
        super
      end
      
    end
  end
end