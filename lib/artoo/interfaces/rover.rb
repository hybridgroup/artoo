require 'artoo/interfaces/interface'

module Artoo
  module Interfaces
    # The Rover interface.
    class Rover < Interface
      COMMANDS = [:forward, :backward, :turn_left, :turn_right, :stop]

      def forward(speed)
      end

      def backward(speed)
      end

      def turn_left(degrees)
      end

      def turn_right(degrees)
      end

      def stop
      end
    end
  end
end
