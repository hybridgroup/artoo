require 'artoo/interfaces/interface'

module Artoo
  module Interfaces
    # The Ping interface.
    class Ping < Interface
      def interface_type
        :ping
      end

      COMMANDS = [:ping]

      def ping
      end
    end
  end
end
