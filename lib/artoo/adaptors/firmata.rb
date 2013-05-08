require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to Arduino using Firmata
    # @see http://rubydoc.info/gems/hybridgroup-firmata/0.3.0/Firmata/Board HybridGroup Firmata Documentation
    class Firmata < Adaptor
      attr_reader :firmata

      # Creates connection with firmata board
      # @return [Boolean]
      def connect
        require 'firmata' unless defined?(::Firmata)
        @firmata = ::Firmata::Board.new(connect_to)
        @firmata.connect
        super
        return true
      end

      # Closes connection with firmata board
      # @return [Boolean]
      def disconnect
        super
      end

      # Uses method missing to call Firmata Board methods
      # @see http://rubydoc.info/gems/hybridgroup-firmata/0.3.0/Firmata/Board Firmata Board Documentation
      def method_missing(method_name, *arguments, &block)
        firmata.send(method_name, *arguments, &block)
      end
    end
  end
end
