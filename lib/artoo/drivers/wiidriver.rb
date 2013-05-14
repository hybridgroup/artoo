require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wii-based controller shared driver behaviors for Firmata
    class Wiidriver < Driver
      attr_reader :joystick, :data

      def address; 0x52; end

      # Create new Wiidriver
      def initialize(params={})
        @joystick = get_defaults
        @data = {}
        super
      end

      # Starts drives and required connections
      def start_driver
        begin
          connection.i2c_config(0)
          every(interval) do
            connection.i2c_write_request(address, 0x40, 0x00)
            connection.i2c_write_request(address, 0x00, 0x00)
            connection.i2c_read_request(address, 6)
            
            connection.read_and_process
            handle_events
          end

          super
        rescue Exception => e
          Logger.error "Error starting wii driver!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      # Get and update data
      def update(value)
        if encrypted?(value)
          Logger.error "Encrypted bytes from wii device!"
          raise "Encrypted bytes from wii device!"
        end

        @data = parse(value)
      end

      def handle_events
        while i = find_event("i2c_reply") do
          update(events.slice!(i).data.first)
        end
      end

      protected

      def find_event(name)
        events.index {|e| e.name == name}
      end

      def events
        connection.async_events
      end

      def get_defaults
        {}
      end

      def parse
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
