require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wiichuck driver behaviors for Firmata
    class Wiichuck < Driver
      def address; 0x52; end

      def start_driver
        listener = ->(value) { update(value) }
        connection.on("i2c_reply", listener)

        connection.i2c_config(10)
        connection.i2c_request(address, 0x40, 0x00)

        every(interval) do
          connection.i2c_request(address, 0x00)
          connection.read_and_process
        end

        super
      end

      def update(value)
        publish("#{parent.name}_update", value)
      end
    end
  end
end