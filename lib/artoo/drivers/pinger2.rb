require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Pings itself
    class Pinger2 < Driver
      COMMANDS = [:ping].freeze

      def start_driver
        every(interval) do
          @count = rand(100000)
          publish(event_topic_name("update"), "alive", @count)
          publish(event_topic_name("alive"), @count)
        end

        super
      end

      def ping
        puts "pong"
      end
    end
  end
end