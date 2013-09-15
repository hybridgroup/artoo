require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # DeviceInfo driver behaviors
    class DeviceInfo < Driver
      COMMANDS = [:firmware_name, :version, :connect].freeze

      def firmware_name
        connection.firmware_name
      end

      def version
        connection.version
      end
    end
  end
end
