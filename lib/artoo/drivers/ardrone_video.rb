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
        publish("#{parent.name}_frame", frame)
      end
    end
  end
end