require 'json'

module Artoo
  module Api

    # The Artoo::Api::DeviceEventClient class is how a websocket client can subscribe
    # to event notifications for a specific device.
    # Example: ardrone nav data
    class DeviceEventClient
      include Celluloid
      include Celluloid::Notifications
      include Celluloid::Logger

      attr_reader :topic

      # Create new event client
      # @param [Socket] websocket
      # @param [String] topic
      def initialize(connection, topic)
        @io = Reel::Response::Writer.new(connection.socket)

        connection.detach

        connection.respond(:ok, {
          'Content-Type' => 'text/event-stream',
          'Connection' => 'keep-alive',
          'Transfer-Encoding' => 'chunked',
          'Cache-Control' => 'no-cache'
        })

        subscribe(topic, :notify_event)
      end

      # Event notification
      # @param [String] topic
      # @param [Object] data
      def notify_event(topic, *data)
        @io.write "data: #{JSON.dump(data[0])}\n\n"
      end
    end
  end
end
