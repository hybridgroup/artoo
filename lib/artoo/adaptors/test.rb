require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # This class is used for testing
    class Test < Adaptor
      def connect
        super
        Logger.info "Test adapter connected."
      end

      def disconnect
        super
        Logger.info "Test adapter disconnected."
      end

      def reconnect
        Logger.info "Test adapter reconnecting..."
        super
      end

      def method_missing(method_name, *arguments, &block)
        Logger.info "Test adapter called '#{method_name}'."
        true
      end
    end
  end
end
