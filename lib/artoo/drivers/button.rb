require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Button driver behaviors for Firmata
    class Button < Driver
      DOWN = 1
      UP = 0

      def is_pressed?
        (@is_pressed ||= false) == true
      end

      def start_driver
        listener = ->(value) { update(value) }
        connection.on("digital-read-#{pin}", listener)
        connection.set_pin_mode(pin, Firmata::Board::INPUT)
        connection.toggle_pin_reporting(pin)

        every(interval) do
          connection.read_and_process
        end

        super
      end

      def update(value)
        if value == DOWN
          @is_pressed = true
          publish("#{parent.name}_push", value)
        else
          @is_pressed = false
          publish("#{parent.name}_release", value)
        end
      end
    end
  end
end