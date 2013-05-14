require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The LED driver behaviors
    class Led < Driver

      COMMANDS = [:on, :off, :toggle, :brightness].freeze

      # @return [Boolean] True if on
      def is_on?
        (@is_on ||= false) == true
      end

      # @return [Boolean] True if off
      def is_off?
        (@is_on ||= false) == false
      end

      # Sets led to on status
      def on
        @is_on = true
        connection.set_pin_mode(pin, Firmata::Board::OUTPUT)
        connection.digital_write(pin, Firmata::Board::HIGH)
      end

      # Sets led to off status
      def off
        @is_on = false
        connection.set_pin_mode(pin, Firmata::Board::OUTPUT)
        connection.digital_write(pin, Firmata::Board::LOW)
      end

      # Toggle status
      # @example on > off, off > on
      def toggle
        is_off? ? on : off
      end

      # Change brightness level
      # @param [Integer] level
      def brightness(level=0)
        connection.set_pin_mode(pin, Firmata::Board::PWM)
        connection.analog_write(pin, level)
      end
    end
  end
end
