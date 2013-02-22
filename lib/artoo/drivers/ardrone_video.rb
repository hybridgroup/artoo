require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone video driver behaviors
    class ArdroneVideo < Driver
      def start_driver
        every(interval) do
          handle_frame
        end

        super
      end

      def handle_frame(*params)
        frame = connection.video_parser.get_frame
        publish(event_topic_name("update"), "frame", frame)
        publish(event_topic_name("frame"), frame)
      end
    end
  end
end