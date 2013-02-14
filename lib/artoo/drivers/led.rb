require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The LED driver behaviors
    class Led < Driver
      def on
        connection.digital_write(pin, Firmata::Board::HIGH)
      end

      def off
        connection.digital_write(pin, Firmata::Board::LOW)
      end
    end
  end
end