require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # DeviceInfo driver behaviors
    class DeviceInfo < Driver
      COMMANDS = [:name, :version, :connect].freeze
    end
  end
end
