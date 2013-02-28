require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a Roomba (http://www.irobot.com/en/us/robots/Educators/Create.aspx)
    class Roomba < Adaptor
      
      START = 128
      
      module Modes
        FULL = 132
      end
      
      attr_reader :sp

      def finalize
        if connected?
          @sp.close
        end
      end

      def connect(dev)
        require 'serialport'
        @sp = SerialPort.new(dev, 57600)
        @sp.dtr = 0
        @sp.rts = 0

        send_bytes(START.chr)
        send_bytes(Modes::FULL.chr)
        
        super
      rescue LoadError
        puts "Please 'gem install hybridgroup-serialport' for serial port support."
      end
      
      def send_bytes(bytes)
        Logger.info "sending: #{bytes.inspect}"
        res = @sp.write(bytes)
        Logger.info "returned: #{res}"
      end

      def disconnect
        @sp.close
        super
      end

      def method_missing(method_name, *arguments, &block)
        send_bytes(method_name, *arguments, &block)
      end
      
    end
  end
end