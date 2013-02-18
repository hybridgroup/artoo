require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone video driver behaviors
    class ArdroneVideo < Driver
      def start
        every(interval) do
          handle_frame
        end

        super
      end

      def handle_frame
        frame = parser.get_frame
        publish("#{parent.name}_frame", frame)
      end
    end
  end
end