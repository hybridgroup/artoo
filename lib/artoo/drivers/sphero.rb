require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Sphero driver behaviors
    class Sphero < Driver
      RED     = [255, 0, 0]
      GREEN   = [0, 255, 0]
      YELLOW  = [255, 255, 0]
      BLUE    = [0, 0, 255]
      WHITE   = [255, 255, 255]

      # Detects collisions
      # @param [Hash] params
      def detect_collisions(params={})
        connection.configure_collision_detection 0x01, 0x20, 0x20, 0x20, 0x20, 0x50
      end

      # Clears collisions
      def clear_collisions
        messages.clear if responses = messages
      end

      # @return [CollisionDetected] collision
      def collisions
        matching_response_types messages, ::Sphero::Response::CollisionDetected
      end

      # @return [PowerNotification] power notification
      def power_notifications
        matching_response_types messages, ::Sphero::Response::PowerNotification
      end

      # @return [SensorData] sensor data
      def sensor_data
        matching_response_types messages, ::Sphero::Response::SensorData
      end

      # Set color
      # @param [Collection] colors
      def set_color(*colors)
        connection.rgb(*color(*colors))
      end

      # Retrieves color
      # @param [Collection] colors
      def color(*colors)
        case colors.first
        when :red    then RED
        when :green  then GREEN
        when :yellow then YELLOW
        when :blue   then BLUE
        when :white  then WHITE
        else colors
        end
      end

      private

      def matching_response_types(responses, respone_klass)
        responses.select { |m| m.is_a? respone_klass } if responses
      end

      def messages
        connection.async_messages
      end
    end
  end
end
