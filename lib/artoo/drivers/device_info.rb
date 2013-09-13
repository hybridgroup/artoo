require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # DeviceInfo driver behaviors
    class DeviceInfo < Driver
      COMMANDS = [:name, :version, :connect].freeze

      def name
        connection.device_name
      end

      def version
        connection.device_version
      end
    end
  end
end
