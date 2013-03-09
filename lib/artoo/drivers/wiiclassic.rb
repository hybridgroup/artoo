require 'artoo/drivers/wiidriver'

module Artoo
  module Drivers
    # Wiiclassic driver behaviors for Firmata
    class Wiiclassic < Wiidriver      
      def update(value)
        begin
          super

          @data = parse_wiiclassic(value)
          
          adjust_origins
          update_buttons
          update_left_joystick
          update_right_joystick
          update_triggers

        rescue Exception => e
          Logger.error "wiiclassic update exception!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def adjust_origins
        set_joystick_default_value(:ly_origin, data[:ly])
        set_joystick_default_value(:lx_origin, data[:lx])
        set_joystick_default_value(:ry_origin, data[:ry])
        set_joystick_default_value(:rx_origin, data[:rx])
        set_joystick_default_value(:rt_origin, data[:rt])
        set_joystick_default_value(:lt_origin, data[:lt])
      end

      def update_buttons
        publish(event_topic_name("a_button")) if data[:a] == true
        publish(event_topic_name("b_button")) if data[:b] == true
        publish(event_topic_name("x_button")) if data[:x] == true
        publish(event_topic_name("y_button")) if data[:y] == true
        publish(event_topic_name("home_button")) if data[:h] == true
        publish(event_topic_name("start_button")) if data[:+] == true
        publish(event_topic_name("select_button")) if data[:-] == true
      end

      def update_left_joystick
        publish(event_topic_name("left_joystick"), {:x => calculate_joystick_value(:lx, :lx_origin), :y => calculate_joystick_value(:ly, :ly_origin)})
      end

      def update_right_joystick
        publish(event_topic_name("right_joystick"), {:x => calculate_joystick_value(:rx, :rx_origin), :y => calculate_joystick_value(:ry, :ry_origin)})
      end

      def update_triggers
        publish(event_topic_name("right_trigger"), calculate_joystick_value(:rt, :rt_origin))
        publish(event_topic_name("left_trigger"), calculate_joystick_value(:lt, :lt_origin))
      end

      private
      
      def get_defaults
        {
          :ry_origin => nil,
          :rx_origin => nil,
          :ly_origin => nil,
          :lx_origin => nil,
          :rt_origin => nil,
          :lt_origin => nil
        }  
      end      

      def parse_wiiclassic(value)
        return {
          :lx => decode_value(value, 0) & 0x3f,
          :ly => decode_value(value, 1) & 0x3f,
          :rx => ((decode_value(value, 0) & 0xC0) >> 2)  | ((decode_value(value, 1) & 0xC0) >> 4) | (decode_value(value, 2)[7]),
          :ry => decode_value(value, 2) & 0x1f,
          :lt => ((decode_value(value, 2) & 0x60) >> 3) | ((decode_value(value, 3) & 0xC0) >> 6),
          :rt => decode_value(value, 3) & 0x1f,
          :d_up => generate_bool(decode_value(value, 5)[0]),
          :d_down => generate_bool(decode_value(value, 4)[6]),
          :d_left => generate_bool(decode_value(value, 5)[1]),
          :d_right => generate_bool(decode_value(value, 4)[7]),
          :zr => generate_bool(decode_value(value, 5)[2]),
          :zl => generate_bool(decode_value(value, 5)[7]),
          :a => generate_bool(decode_value(value, 5)[4]),
          :b => generate_bool(decode_value(value, 5)[6]),
          :x => generate_bool(decode_value(value, 5)[3]),
          :y => generate_bool(decode_value(value, 5)[5]),
          :+ => generate_bool(decode_value(value, 4)[2]),
          :- => generate_bool(decode_value(value, 4)[4]),
          :h => generate_bool(decode_value(value, 4)[3]),
        }
      end
    end
  end
end
