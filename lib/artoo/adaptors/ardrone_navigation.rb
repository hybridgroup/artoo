require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a ARDrone 2.0 (http://ardrone2.parrot.com/) navigation data stream
    class ArdroneNavigation < Adaptor
      attr_reader :ardrone

      def connect
        require 'argus' unless defined?(::Argus)
        @ardrone = Argus::NavStreamer.new(connect_to_udp, port.host, port.port.to_i)
        @ardrone.start
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