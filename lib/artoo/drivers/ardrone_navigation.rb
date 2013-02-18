require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Ardrone navigation driver behaviors
    class ArdroneNavigation < Driver
      def start_driver
        every(interval) do
          handle_update
        end

        super
      end

      def handle_update
        navdata = connection.receive
        publish("#{parent.name}_update", navdata)
      end
    end
  end
end