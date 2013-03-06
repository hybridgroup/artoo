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
        require 'serialport'
        @sp = SerialPort.new(self.port.to_s, 57600, 8, 1, SerialPort::NONE)
        @sp.dtr = 0
        @sp.rts = 0        
        super
      rescue LoadError
        Logger.error "Please 'gem install hybridgroup-serialport' for serial port support."
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