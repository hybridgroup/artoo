require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    class Firmata < Adaptor
      attr_reader :firmata

      def connect
        require 'firmata' unless defined?(::Firmata)
        @firmata = ::Firmata::Board.new(connect_to)
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
