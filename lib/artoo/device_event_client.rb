module Artoo
  # The Artoo::DeviceEventClient class is how a websocket client can subscribe
  # to event notifications for a specific device.
  # Example: ardrone nav data
  class DeviceEventClient
    include Celluloid
    include Celluloid::Notifications
    include Celluloid::Logger

    def initialize(websocket, topic)
      info "Streaming device event notifications to websocket..."
      @socket = websocket
      subscribe(topic, :notify_event)
    end

    def notify_event(topic, data)
      # TODO: send which topic sent the notification
      @socket << data
    rescue Reel::SocketError
      error "Device event notification websocket disconnected"
      terminate
    end
  end
end
