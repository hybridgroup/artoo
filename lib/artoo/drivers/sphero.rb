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
    end
  end
end