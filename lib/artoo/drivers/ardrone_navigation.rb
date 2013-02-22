require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone navigation driver behaviors
    class ArdroneNavigation < Driver
      def start_driver
        every(interval) do
          handle_update
        end

        super
      end

      def handle_update
        navdata = connection.receive_data
        publish(event_topic_name("update"), navdata)
      end
    end
  end
end