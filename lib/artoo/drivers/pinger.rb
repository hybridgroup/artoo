require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Pings itself
    class Pinger < Driver
      def start
        every(interval) do
          Logger.info "#{parent.name}_alive"
          publish("#{parent.name}_alive", 'yes')
        end

        super
      end
    end
  end
end