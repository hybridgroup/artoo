require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Servo behaviors for Firmata
    class Servo < Driver
      COMMANDS = [:move, :min, :center, :max].freeze

      attr_reader :current_angle

      def initialize(params={})
        super

        @current_angle = 0
      end

      def start_driver
        every(interval) do
          connection.read_and_process
        end

        super
      end

      def move(angle)
        raise "Servo angle must be an integer between 0-180" unless (angle.is_a?(Numeric) && angle >= 0 && angle <= 180)
        
        @current_angle = angle
        connection.set_pin_mode(pin, Firmata::Board::SERVO)
        connection.analog_write(pin, angle_to_span(angle))
      end

      def min
        move(0)
      end

      def center
        move(90)
      end

      def max
        move(180)
      end

      # converts an angle to a span between 0-255
      def angle_to_span(angle)
        (angle * 255 / 180).to_i
      end
    end
  end
end