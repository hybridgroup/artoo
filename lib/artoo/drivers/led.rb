require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The LED driver behaviors
    class Led < Driver
      COMMANDS = [:is_on?, :is_off?, :on, :off, :toggle, :brightness].freeze

      def is_on?
        (@is_on ||= false) == true
      end

      def is_off?
        (@is_on ||= false) == false
      end

      def on
        @is_on = true
        connection.set_pin_mode(pin, Firmata::Board::OUTPUT)
        connection.digital_write(pin, Firmata::Board::HIGH)
      end

      def off
        @is_on = false
        connection.set_pin_mode(pin, Firmata::Board::OUTPUT)
        connection.digital_write(pin, Firmata::Board::LOW)
      end

      def toggle
        is_off? ? on : off
      end

      def brightness(level=0)
        connection.set_pin_mode(pin, Firmata::Board::PWM)
        connection.analog_write(pin, level)
      end
    end
  end
end