require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a ARDrone 2.0 (http://ardrone2.parrot.com/) video data stream
    class ArdroneVideo < Adaptor
      attr_reader :ardrone, :video_parser

      def connect
        require 'argus' unless defined?(::Argus)
        @ardrone = Argus::TcpVideoStreamer.new(connect_to_tcp, port.host, port.port)
        @video_parser = Argus::PaVEParser.new(ardrone)
        @ardrone.start_stream(connect_to_udp)
        super
      end

      def disconnect
        ardrone.close
        super
      end

      def method_missing(method_name, *arguments, &block)
        ardrone.send(method_name, *arguments, &block)
      end
    end
  end
end