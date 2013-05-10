require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone navigation driver behaviors
    class ArdroneNavigation < Driver

      # Starts driver and handle updates from device
      def start_driver
        every(interval) do
          handle_update
        end

        super
      end

      # Receives data from navigation and publishes
      # and event in update topic for it
      def handle_update
        navdata = connection.receive_data
        publish(event_topic_name("update"), navdata)
      end
    end
  end
end
