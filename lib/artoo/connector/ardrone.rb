require 'artoo/connector/connect'

module Artoo
  module Connector
    # Connect to a ARDrone 2.0 (http://ardrone2.parrot.com/)
    class Ardrone < Connect
      attr_reader :ardrone

      def finalize
        if connected?
          ardrone.land
          ardrone.stop
        end
      end

      def connect
        require 'argus' unless defined?(::Argus)
        @ardrone = Argus::Drone.new
        super
      end

      def disconnect
        ardrone.stop
        super
      end

      def method_missing(method_name, *arguments, &block)
        ardrone.send(method_name, *arguments, &block)
      end
    end
  end
end