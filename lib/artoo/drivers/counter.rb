require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Test driver to count up
    class Counter < Driver

      COMMANDS = [:count].freeze

      # Publishes events to update and alive event topics
      # with incremental count
      def start_driver
        @count = 0
        every(interval) do
          @count += 1
          publish(event_topic_name("update"), "count", @count)
          publish(event_topic_name("count"), @count)
        end

        super
      end

      def count
        @count
      end
    end
  end
end
