require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Sphero driver behaviors
    class Sphero < Driver
      def collisions
        connection.async_messages.select {|m| m.is_a?(::Sphero::Response::CollisionDetected)}
      end

      def power_notifications
        connection.async_messages.select {|m| m.is_a?(::Sphero::Response::PowerNotification)}
      end

      def sensor_data
        connection.async_messages.select {|m| m.is_a?(::Sphero::Response::SensorData)}
      end

      def set_color(*rgb)
        connection.rgb(color(rgb))
      end

      def color(*rgb)
        r, g, b = case rgb[0]
        when :red
          [255, 0, 0]
        when :green
          [0, 255, 0]
        when :yellow
          [255, 255, 0]
        when :blue
          [0, 0, 255]
        when :white
          [255, 255, 255]
        else
          rgb
        end
      end
    end
  end
end