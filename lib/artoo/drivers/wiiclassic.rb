require 'artoo/drivers/wiidriver'

module Artoo
  module Drivers
    # Wiiclassic driver behaviors for Firmata
    class Wiiclassic < Wiidriver

      # Update buttons and joysticks values
      # @param [Object] value
      def update(value)
        begin
          super

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

      # Adjust all origins
      def adjust_origins
        set_joystick_default_value(:ly_origin, data[:ly])
        set_joystick_default_value(:lx_origin, data[:lx])
        set_joystick_default_value(:ry_origin, data[:ry])
        set_joystick_default_value(:rx_origin, data[:rx])
        set_joystick_default_value(:rt_origin, data[:rt])
        set_joystick_default_value(:lt_origin, data[:lt])
      end

      # Update button values
      def update_buttons
        update_button("a_button", :a)
        update_button("b_button", :b)
        update_button("x_button", :x)
        update_button("y_button", :y)
        update_button("home_button", :h)
        update_button("start_button", :+)
        update_button("select_button", :-)
      end

      # Publish button event
      def update_button(name, key)
        publish(event_topic_name(name)) if data[key] == true
      end

      # Publish left joystick event
      def update_left_joystick
        publish(event_topic_name("left_joystick"), {:x => calculate_joystick_value(:lx, :lx_origin), :y => calculate_joystick_value(:ly, :ly_origin)})
      end

      # Publish right joystick event
      def update_right_joystick
        publish(event_topic_name("right_joystick"), {:x => calculate_joystick_value(:rx, :rx_origin), :y => calculate_joystick_value(:ry, :ry_origin)})
      end

      # Publish triggers events
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

      def parse(value)
        return parse_joysticks(value).
          merge(parse_buttons(value)).
          merge(parse_triggers(value)).
          merge(parse_dpad(value)).
          merge(parse_zbuttons(value))
      end

      def parse_joysticks(value)
        {
          :lx => decode_value(value, 0) & 0x3f,
          :ly => decode_value(value, 1) & 0x3f,
          :rx => ((decode_value(value, 0) & 0xC0) >> 2)  | ((decode_value(value, 1) & 0xC0) >> 4) | (decode_value(value, 2)[7]),
          :ry => decode_value(value, 2) & 0x1f
        }
      end

      def parse_buttons(value)
        {
          :a => get_bool_decoded_value(value, 5, 4),
          :b => get_bool_decoded_value(value, 5, 6),
          :x => get_bool_decoded_value(value, 5, 3),
          :y => get_bool_decoded_value(value, 5, 5),
          :+ => get_bool_decoded_value(value, 4, 2),
          :- => get_bool_decoded_value(value, 4, 4),
          :h => get_bool_decoded_value(value, 4, 3)
        }
      end

      def parse_triggers(value)
        {
          :lt => ((decode_value(value, 2) & 0x60) >> 3) | ((decode_value(value, 3) & 0xC0) >> 6),
          :rt => decode_value(value, 3) & 0x1f
        }
      end

      def parse_dpad(value)
        {
          :d_up => get_bool_decoded_value(value, 5, 0),
          :d_down => get_bool_decoded_value(value, 4, 6),
          :d_left => get_bool_decoded_value(value, 5, 1),
          :d_right => get_bool_decoded_value(value, 4, 7)
        }
      end

      def parse_zbuttons(value)
        {
          :zr => get_bool_decoded_value(value, 5, 2),
          :zl => get_bool_decoded_value(value, 5, 7)
        }
      end

      def get_bool_decoded_value(value, offset1, offset2)
        generate_bool(decode_value(value, offset1)[offset2])
      end
    end
  end
end
