require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone driver behaviors
    # @see https://github.com/hybridgroup/argus/blob/master/lib/argus/drone.rb Argus::Drone docs for supported actions
    class Ardrone < Driver
      def start
        connection.start(false) # send false, so Argus does not use NavMonitor
      end
    end
  end
end
