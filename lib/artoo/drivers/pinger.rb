require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Pings itself
    class Pinger < Driver

      COMMANDS = [:ping].freeze

      # Publishes events to update and alive event topics
      # with incremental count
      def start_driver
        @count = 1
        every(interval) do
          publish(event_topic_name("update"), "alive", @count)
          publish(event_topic_name("alive"), @count)
          @count += 1
        end

        super
      end

      def ping
        "pong"
      end
    end
  end
end
