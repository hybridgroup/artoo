require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a ARDrone 2.0  video data stream
    # @see http://rubydoc.info/gems/hybridgroup-argus/0.2.0/Argus/TcpVideoStreamer TCP Video Streamer Documentation
    # @see http://rubydoc.info/gems/hybridgroup-argus/0.2.0/Argus/PaVEParser PaVEParser Documentation
    class ArdroneVideo < Adaptor
      attr_reader :ardrone, :video_parser

      # Creates connection to Argus TCP Video Streamer and
      # Argus PaVE Parser starting a stream with ardrone device
      # @return [Boolean]
      def connect
        require 'argus' unless defined?(::Argus)
        @ardrone = Argus::VideoStreamer.new(connect_to_tcp, port.host, port.port)
        @ardrone.start(connect_to_udp)
        super
      end

      # Closes ardrone connection
      # @return [Boolean]
      def disconnect
        ardrone.close
        super
      end

      # Calls ardrone actions using method missing
      # @see https://github.com/hybridgroup/argus/blob/master/lib/argus/drone.rb hybridgroup-argus Drone
      def method_missing(method_name, *arguments, &block)
        ardrone.send(method_name, *arguments, &block)
      end
    end
  end
end
