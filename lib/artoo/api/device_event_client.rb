require 'json'

module Artoo
  module Api

    class SSE
      def initialize(io)
        @io = io
      end

      def write(object, options={})
        options.each do |k,v|
          @io.write "#{k}: #{v}\n"
        end

        @io.write "data: #{JSON.dump(object)}\n\n"
      end

      def close
        @io.close
      end
    end

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
        headers = {'Content-Type' => 'text/event-stream', 'Transfer-Encoding' => 'chunked'}
        @sse = SSE.new(connection)

        connection.detach
        connection.respond(:ok, headers)
        subscribe(topic, :notify_event)
      end

      # Event notification
      # @param [String] topic
      # @param [Object] data
      def notify_event(topic, *data)
        @sse.write({:data => data}, :event => topic)
      end
    end
  end
end
