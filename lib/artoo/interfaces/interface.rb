module Artoo
  module Interfaces
    # The Interface class is the base class used to
    # implement behavior for a specific category of robot. Examples
    # would be a Rover or Copter.
    #
    # Derive a class from this class, in order to implement higher-order 
    # behavior for a new category of robot.
    class Interface
      include Celluloid
      include Celluloid::Notifications

      attr_accessor :name, :robot, :device

      COMMANDS = [].freeze

      # Create new interface
      # @param [Hash] params
      # @option params [Object] :robot
      # @option params [Object] :device
      def initialize(params={})
        @name = params[:name]
        @robot = params[:robot]
        @device = params[:device]
      end
    end
  end
end
