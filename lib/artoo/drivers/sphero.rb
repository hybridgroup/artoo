require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Sphero driver with special behaviors
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

      def method_missing(method_name, *arguments, &block)
        connection.send(method_name, *arguments, &block)
      rescue Exception => e
        Logger.error e.message
        Logger.error e.backtrace.inspect
        return nil
      end
    end
  end
end