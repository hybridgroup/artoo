require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone driver behaviors
    # @see https://github.com/hybridgroup/argus/blob/master/lib/argus/drone.rb Argus::Drone docs for supported actions
    class Ardrone < Driver
      COMMANDS = [:start, :stop, :hover, :land, :take_off, :emergency, :front_camera, :bottom_camera, :up, :down, :left, :right, :forward, :backward, :turn_left, :turn_right].freeze

      def start
        connection.start(false) # send false, so Argus does not use NavMonitor
      end
    end
  end
end
