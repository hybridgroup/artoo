require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wii-based controller shared driver behaviors for Firmata
    class Wiidriver < Driver
      attr_reader :joystick, :data

      def address; 0x52; end

      def initialize(params={})
        @joystick = get_defaults
        @data = {}
        super
      end

      def start_driver
        begin
          listener = ->(value) { update(value) }
          connection.on("i2c_reply", listener)

          connection.i2c_config(0)
          every(interval) do
            connection.i2c_write_request(address, 0x40, 0x00)
            p
            connection.i2c_write_request(address, 0x00, 0x00)
            p
            connection.i2c_read_request(address, 6)
            p
            connection.read_and_process
          end

          super
        rescue Exception => e
          p "start driver"
          p e.message
          p e.backtrace.inspect
        end
      end

      def update(value)
        if encrypted?(value)
          Logger.error "Encrypted bytes from wii device!"
          raise "Encrypted bytes from wii device!"
        end
      end

      protected 

      def get_defaults
        {}
      end

      def set_joystick_default_value(joystick_axis, default_value)
        joystick[joystick_axis] = default_value if joystick[joystick_axis].nil?
      end

      def calculate_joystick_value(axis, origin)
        data[axis] - joystick[origin]
      end

      def encrypted?(value)
        [[0, 1], [2, 3], [4, 5]].all? {|a| get_value(value, a[0]) == get_value(value, a[1]) }
      end

      def decode(x)
        return ( x ^ 0x17 ) + 0x17
      end

      def decode_value(value, index)
        decode(get_value(value, index))
      end

      def get_value(value, index)
        value[:data][index]
      end

      def generate_bool(value)
        value == 0 ? true : false
      end
    end
  end
end
