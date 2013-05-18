require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Test driver that can be pinged itself
    class Pinger < Driver

      COMMANDS = [:ping].freeze

      def start_driver
        @count = 0
        super
      end

      # Publishes events to update event topic
      # when pinged
      def ping
        @count += 1
        publish(event_topic_name("update"), "ping", @count)
        publish(event_topic_name("ping"), @count)
        "ping #{@count}"
      end
    end
  end
end
