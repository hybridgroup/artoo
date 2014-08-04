require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Test driver that can be pinged itself
    class Ping < Driver

      COMMANDS = [:ping].freeze

      def start_driver
        super
      end

      # Publishes events to update event topic
      # when pinged
      def ping
        data = 'pong'
        publish(event_topic_name("update"), "ping", data)
        publish(event_topic_name("ping"), data)

        data
      end
    end
  end
end
