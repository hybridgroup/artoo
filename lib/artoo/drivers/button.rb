require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Button driver behaviors for Firmata
    class Button < Driver
      def is_pressed?
        (@is_pressed ||= false) == true
      end

      def start
        every(0.2) do
          puts "yo"  
        end

        super
      end
    end
  end
end