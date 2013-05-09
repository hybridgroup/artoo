module Artoo
  # The Artoo::DeviceEventClient class is how a websocket client can subscribe
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
    def initialize(websocket, topic)
      @topic = topic
      info "Streaming #{@topic} to websocket..."
      @socket = websocket
      subscribe(@topic, :notify_event)
    end

    # Event notification
    # @param [String] topic
    # @param [Object] data
    def notify_event(topic, *data)
      # TODO: send which topic sent the notification
      @socket << data.last.to_s
    rescue Reel::SocketError, Errno::EPIPE
      info "Device event notification #{topic} websocket disconnected"
      terminate
    end
  end
end
