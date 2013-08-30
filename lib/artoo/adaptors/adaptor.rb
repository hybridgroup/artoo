module Artoo
  module Adaptors
    # The Adaptor class is the base class used to connect to a specific group
    # of hardware devices. Examples would be an Arduino, a Sphero, or an ARDrone.
    #
    # Derive a class from this class, in order to implement communication
    # with a new type of hardware device.
    # @see https://github.com/celluloid/celluloid-io Celluloid::IO Documentation
    class Adaptor
      include Celluloid::IO

      attr_reader :parent, :port, :additional_params

      # Initialize an adaptor
      # @param params [hash]
      # @option params [String] :parent
      # @option params [String] :port
      # @option params [String] :additional_params
      def initialize(params={})
        @parent = params[:parent]
        @port = params[:port]
        @additional_params = params[:additional_params]
        @connected = false
      end

      # Makes connected flag true
      # @return [Boolean]
      def connect
        @connected = true
      end

      # Makes connected flag false
      # @return [Boolean]
      def disconnect
        @connected = false
        true
      end

      # Makes connected flag true
      # @return [Boolean] true unless connected
      def reconnect
        connect unless connected?
      end

      # @return [Boolean] connected flag status
      def connected?
        @connected == true
      end

      # Connects to configured port
      # @return [TCPSocket] tcp socket of tcp port
      # @return [String] port configured
      def connect_to
        if port.is_tcp?
          connect_to_tcp
        else
          port.port
        end
      end

      # @return [TCPSocket] TCP socket connection
      def connect_to_tcp
        @socket ||= TCPSocket.new(port.host, port.port)
      end
      
      # @return [UDPSocket] UDP socket connection
      def connect_to_udp
        @udp_socket ||= UDPSocket.new
      end

      # Creates serial connection
      # @param speed [int]
      # @param data_bits [int]
      # @param stop_bits [int]
      # @param parity
      # @return [SerialPort] new connection
      def connect_to_serial(speed=57600, data_bits=8, stop_bits=1, parity=nil)
        require 'serialport'
        parity = ::SerialPort::NONE unless parity
        @sp = ::SerialPort.new(port.port, speed, data_bits, stop_bits, parity)
      rescue LoadError
        Logger.error "Please 'gem install hybridgroup-serialport' for serial port support."
      end
    end
  end
end
