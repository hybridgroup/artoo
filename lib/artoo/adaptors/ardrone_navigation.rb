require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a ARDrone 2.0 navigation data stream
    # @see http://rubydoc.info/gems/hybridgroup-argus/0.2.0/Argus/NavStreamer Argus NavStremer Documentation
    class ArdroneNavigation < Adaptor
      attr_reader :ardrone

      # Creates connection with Argus NavStreamer and starts ardrone device
      # @return [Boolean]
      def connect
        require 'argus' unless defined?(::Argus)
        @ardrone = Argus::NavStreamer.new(connect_to_udp, port.host, port.port.to_i)
        @ardrone.start
        super
      end

      # Closes connection with ardrone device
      # @return [Boolean]
      def disconnect
        ardrone.close
        super
      end

      # Calls ardrone actions using method missing
      # @see http://rubydoc.info/gems/hybridgroup-argus/0.2.0/Argus/Drone Argus Drone Documentation
      def method_missing(method_name, *arguments, &block)
        ardrone.send(method_name, *arguments, &block)
      end
    end
  end
end
