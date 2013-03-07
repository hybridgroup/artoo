require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wiiclassic driver behaviors for Firmata
    class Wiiclassic < Driver
      attr_reader :joystick

      def address; 0x52; end

      INITIAL_DEFAULTS = {
        :ry_origin => nil,
        :rx_origin => nil,
        :ly_origin => nil,
        :lx_origin => nil,
        :rt_origin => nil,
        :lt_origin => nil
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
            Logger.error "Encrypted bytes from wiiclassic!"
            return
          end

          data = parse_wiiclassic(value)
          
          adjust_origins(data)
          update_buttons(data)
          update_left_joystick(data)
          update_right_joystick(data)
          update_triggers(data)

        rescue Exception => e
          Logger.error "wiiclassic update exception!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def adjust_origins(data)
        set_joystick_default_value(:ly_origin, data[:ly])
        set_joystick_default_value(:lx_origin, data[:lx])
        set_joystick_default_value(:ry_origin, data[:ry])
        set_joystick_default_value(:rx_origin, data[:rx])
        set_joystick_default_value(:rt_origin, data[:rt])
        set_joystick_default_value(:lt_origin, data[:lt])
      end

      def set_joystick_default_value(joystick_axis, default_value)     
        joystick[joystick_axis] = default_value if joystick[joystick_axis].nil?
      end

      def update_buttons(data)
        publish(event_topic_name("a_button")) if data[:a] == true
        publish(event_topic_name("b_button")) if data[:b] == true
        publish(event_topic_name("x_button")) if data[:x] == true
        publish(event_topic_name("y_button")) if data[:y] == true
        publish(event_topic_name("home_button")) if data[:h] == true
        publish(event_topic_name("start_button")) if data[:+] == true
        publish(event_topic_name("select_button")) if data[:-] == true
      end

      def update_left_joystick(data)
        publish(event_topic_name("left_joystick"), {:x => data[:lx] - @joystick[:lx_origin], :y => data[:ly] - @joystick[:ly_origin]}) 
      end

      def update_right_joystick(data)
        publish(event_topic_name("right_joystick"), {:x => data[:rx] - @joystick[:rx_origin], :y => data[:ry] - @joystick[:ry_origin]}) 
      end

      def update_triggers(data)
        publish(event_topic_name("right_trigger"), data[:rt] - @joystick[:rt_origin])
        publish(event_topic_name("left_trigger"), data[:lt] - @joystick[:lt_origin])
      end

      private 

      def encrypted?(value)
        value[:data][0] == value[:data][1] && value[:data][2] == value[:data][3] && value[:data][4] == value[:data][5]
      end

      def decode( x )
        return ( x ^ 0x17 ) + 0x17
      end

      def get_value(value, index)
        decode(value[:data][index])
      end

      def parse_wiiclassic(value)
        return {
          :lx => get_value(value, 0) & 0x3f,
          :ly => get_value(value, 1) & 0x3f,
          :rx => ((get_value(value, 0) & 0xC0) >> 2)  | ((get_value(value, 1) & 0xC0) >> 4) | (get_value(value, 2)[7]),
          :ry => get_value(value, 2) & 0x1f,
          :lt => ((get_value(value, 2) & 0x60) >> 3) | ((get_value(value, 3) & 0xC0) >> 6),
          :rt => get_value(value, 3) & 0x1f,
          :d_up => generate_bool(get_value(value, 5)[0]),
          :d_down => generate_bool(get_value(value, 4)[6]),
          :D_left => generate_bool(get_value(value, 5)[1]),
          :D_right => generate_bool(get_value(value, 4)[7]),
          :zr => generate_bool(get_value(value, 5)[2]),
          :zl => generate_bool(get_value(value, 5)[7]),
          :a => generate_bool(get_value(value, 5)[4]),
          :b => generate_bool(get_value(value, 5)[6]),
          :x => generate_bool(get_value(value, 5)[3]),
          :y => generate_bool(get_value(value, 5)[5]),
          :+ => generate_bool(get_value(value, 4)[2]),
          :- => generate_bool(get_value(value, 4)[4]),
          :h => generate_bool(get_value(value, 4)[3]),
        }
      end

      def generate_bool(value)
        value == 0 ? true : false
      end
    end
  end
end
