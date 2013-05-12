require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone video driver behaviors
    class ArdroneVideo < Driver

      # Starts drives and handles video frame
      def start_driver
        every(interval) do
          handle_frame
        end

        super
      end

      # Retrieves frame from video connection
      # and publishes data to update and frame
      # event topics
      def handle_frame(*params)
        video = connection.receive_data
        publish(event_topic_name("update"), "video", video)
        publish(event_topic_name("frame"), video.frame)
      end
    end
  end
end
