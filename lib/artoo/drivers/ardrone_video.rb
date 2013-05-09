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
        frame = connection.video_parser.get_frame
        publish(event_topic_name("update"), "frame", frame)
        publish(event_topic_name("frame"), frame)
      end
    end
  end
end
