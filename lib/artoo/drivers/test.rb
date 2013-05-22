require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Test driver
    class Test < Driver
      def start_driver
        Logger.info "Test driver starting..."

        super
      end

      def command(method_name, *arguments)
        if method_name == "publish"
          super
        else
          Logger.info "Driver command '#{method_name}'"
          true
        end
      end
    end
  end
end
