require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Button driver behaviors for Firmata
    class Button < Driver
      def is_pressed?
        (@is_pressed ||= false) == true
      end

      def start
        every(1) do
          Logger.info "yo"  
        end

        super
      end
    end
  end
end