require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # L293 or other H-bridge style motor driver behaviors for Firmata
    class Motor < Driver
      COMMANDS = [:forward, :backward, :stop, :speed, :current_speed].freeze

      attr_reader :leg1_pin, :leg2_pin, :speed_pin, :current_speed

      # Create new Motor
      def initialize(params={})
        super

        raise "Invalid pins, please pass an array in format [leg1, leg2, speed]" unless (pin && pin.is_a?(Array) && pin.size == 3)
        @leg1_pin = pin[0]
        @leg2_pin = pin[1]
        @speed_pin = pin[2]
        @current_speed = 0
      end

      # Starts connection to read and process and driver
      def start_driver
        every(interval) do
          connection.read_and_process
        end

        super
      end

      # Sets movement forward
      # @param [Integer] s speed
      def forward(s)
        set_legs(Firmata::Board::LOW, Firmata::Board::HIGH)
        speed(s)
      end

      # Sets movement backward
      # @param [Integer] s speed
      def backward(s)
        set_legs(Firmata::Board::HIGH, Firmata::Board::LOW)
        speed(s)
      end

      # Stops
      def stop
        speed(0)
      end

      # Set motor speed
      # @param [Integer] s speed (must be an integer between 0-255)
      def speed(s)
        raise "Motor speed must be an integer between 0-255" unless (s.is_a?(Numeric) && s >= 0 && s <= 255)
        @current_speed = s
        connection.set_pin_mode(speed_pin, Firmata::Board::PWM)
        connection.analog_write(speed_pin, s)
      end

      private

      def set_legs(l1, l2)
        connection.set_pin_mode(leg1_pin, Firmata::Board::OUTPUT)
        connection.digital_write(leg1_pin, l1)
        connection.set_pin_mode(leg2_pin, Firmata::Board::OUTPUT)
        connection.digital_write(leg2_pin, l2)
      end
    end
  end
end
