require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Passthru driver just passes calls along to the parent's connection.
    class Passthru < Driver
      def method_missing(method_name, *arguments, &block)
        connection.send(method_name, *arguments, &block)
      rescue Exception => e
        Logger.error e.message
        Logger.error e.backtrace.inspect
        return nil
      end
    end
  end
end