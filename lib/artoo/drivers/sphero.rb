require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Sphero driver behaviors
    class Sphero < Driver
      RED = [255, 0, 0]
      GREEN = [0, 255, 0]
      YELLOW = [255, 255, 0]
      BLUE = [0, 0, 255]
      WHITE = [255, 255, 255]

      def detect_collisions(params={})
        connection.configure_collision_detection 0x01, 0x20, 0x20, 0x20, 0x20, 0x50
      end

      def clear_collisions
        messages = connection.async_messages
        messages.clear if messages
      end

      def collisions
        messages = connection.async_messages
        return nil unless messages
        messages.select {|m| m.is_a?(::Sphero::Response::CollisionDetected)}
      end

      def power_notifications
        messages = connection.async_messages
        return nil unless messages
        messages.select {|m| m.is_a?(::Sphero::Response::PowerNotification)}
      end

      def sensor_data
        messages = connection.async_messages
        return nil unless messages
        messages.select {|m| m.is_a?(::Sphero::Response::SensorData)}
      end

      def set_color(r, g=nil, b=nil)
        r, g, b = color(r, g, b)
        connection.rgb(r, g, b)
      end

      def color(r, g=nil, b=nil)
        case r
        when :red    then RED
        when :green  then GREEN
        when :yellow then YELLOW
        when :blue   then BLUE
        when :white  then WHITE
        else
          return r, g, b
        end
      end
    end
  end
end
