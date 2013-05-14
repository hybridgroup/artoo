require 'artoo/drivers/wiidriver'

module Artoo
  module Drivers
    # Wiichuck driver behaviors for Firmata
    class Wiichuck < Wiidriver

      # Update button and joystick values
      # @param [Object] value
      def update(value)
        begin
          super

          adjust_origins
          update_buttons
          update_joystick

        rescue Exception => e
          Logger.error "wiichuck update exception!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      # Adjust x, y origin values
      def adjust_origins
        set_joystick_default_value(:sy_origin, data[:sy])
        set_joystick_default_value(:sx_origin, data[:sx])
      end

      # Publishes events for c and z buttons
      def update_buttons
        publish(event_topic_name("c_button")) if data[:c] == true
        publish(event_topic_name("z_button")) if data[:z] == true
      end

      # Publishes event for joystick
      def update_joystick
        publish(event_topic_name("joystick"), {:x => calculate_joystick_value(:sx, :sx_origin), :y => calculate_joystick_value(:sy, :sy_origin)})
      end

      private

      def get_defaults
        {
          :sy_origin => nil,
          :sx_origin => nil
        }
      end

      def parse(value)
        return {
          :sx => decode_value(value, 0),
          :sy => decode_value(value, 1),
          :z => generate_bool(decode_value(value, 5) & 0x01),
          :c => generate_bool(decode_value(value, 5) & 0x02)
        }
      end
    end
  end
end
