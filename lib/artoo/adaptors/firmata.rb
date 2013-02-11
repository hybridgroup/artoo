require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    class Firmata < Adaptor
      attr_reader :firmata

      def connect
        require 'firmata' unless defined?(::Firmata)
        c = connect_to
        Logger.info c
        @firmata = ::Firmata::Board.new(c)
        Logger.info 'connecting...'
        @firmata.connect
        Logger.info 'connected'
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
