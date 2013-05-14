require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Pings itself
    class Pinger2 < Driver

      COMMANDS = [:ping].freeze

      # Publishes events to update and alive event topics
      # with random number
      def start_driver
        every(interval) do
          @count = rand(100000)
          publish(event_topic_name("update"), "alive", @count)
          publish(event_topic_name("alive"), @count)
        end

        super
      end

      def ping
        "pong"
      end
    end
  end
end
