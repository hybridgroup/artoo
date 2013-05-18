require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Test driver to obtain a random number
    class Random < Driver

      COMMANDS = [:random].freeze

      # Publishes event to update event topic
      # with random number
      def start_driver
        every(interval) do
          @number = rand(100000)
          publish(event_topic_name("update"), "random", @number)
        end

        super
      end

      def random
        @number
      end
    end
  end
end
