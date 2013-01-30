require 'artoo/connector/connect'

module Artoo
  module Connector
    class Firmata < Connect
      attr_reader :firmata

      def connect
        require 'firmata'
        @firmata ||= ::Firmata::Board.new port
        @firmata.connect
        super
        return true
      end

      def disconnect
        super
      end     

      def method_missing(method_name, *arguments, &block)
        firmata.send(method_name, *arguments, &block)
      end
   end
  end
end
