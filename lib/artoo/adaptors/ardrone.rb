require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # This class connects to a ARDrone 2.0
    # @see http://rubydoc.info/gems/hybridgroup-argus/0.2.0/Argus/Drone Argus Drone Documentation
    class Ardrone < Adaptor
      finalizer :finalize
      attr_reader :ardrone

      # Finalizes connection with ARDrone by landing and stopping the device
      def finalize
        if connected?
          ardrone.land
          ardrone.stop
        end
      end

      # Creates Argus Drone connection with device
      # @return [Boolean]
      def connect
        require 'argus' unless defined?(::Argus)
        @ardrone = Argus::Drone.new(connect_to_udp, port.host, port.port)
        super
      end

      # Disconnects device by stopping it and ending connection
      # @return [Boolean]
      def disconnect
        ardrone.stop
        super
      end

      # Calls Drone actions using method missing
      # Supported actions: [take_off, land hover, emergency, forward backward, left right, up down, turn_left turn_right, front_camera, bottom_camera]
      # @see https://github.com/hybridgroup/argus/blob/master/lib/argus/drone.rb hybridgroup-argus Drone
      def method_missing(method_name, *arguments, &block)
        ardrone.send(method_name, *arguments, &block)
      end
    end
  end
end
