require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wiichuck driver behaviors for Firmata
    class Wiichuck < Driver
      attr_reader :joystick, :data

      def address; 0x52; end

      INITIAL_DEFAULTS = {
          :sy_origin => nil,
          :sx_origin => nil
        }

      def initialize(params={})
        @joystick = INITIAL_DEFAULTS
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
        begin
          if encrypted?(value)
            Logger.error "Encrypted bytes from wiichuck!"
            return
          end

          @data = parse_wiichuck(value)
          
          adjust_origins
          update_buttons
          update_joystick

        rescue Exception => e
          Logger.error "wiichuck update exception!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def adjust_origins
        set_joystick_default_value(:sy_origin, data[:sy])
        set_joystick_default_value(:sx_origin, data[:sx])
      end

      def set_joystick_default_value(joystick_axis, default_value)     
        joystick[joystick_axis] = default_value if joystick[joystick_axis].nil?
      end

      def update_buttons
        publish(event_topic_name("c_button")) if data[:c] == true
        publish(event_topic_name("z_button")) if data[:z] == true
      end

      def update_joystick
        publish(event_topic_name("joystick"), {:x => calculate_joystick_value(:sx, :sx_origin), :y => calculate_joystick_value(:sy, :sy_origin)})
      end

      private 

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

      def parse_wiichuck(value)
        return {
          :sx => decode_value(value, 0),
          :sy => decode_value(value, 1),
          :z => (decode_value(value, 5) & 0x01 == 0 ? true : false ),
          :c => (decode_value(value, 5) & 0x02 == 0 ? true : false )
        }
      end
    end
  end
end
