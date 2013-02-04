module Artoo
  module Drivers
    # The Driver class is the base class used to  
    # implement behavior for a specific kind of hardware devices. Examples 
    # would be an Arduino, a Sphero, or an ARDrone.
    #
    # Derive a class from this class, in order to implement behavior
    # for a new type of hardware device.
    class Driver
      include Celluloid

      attr_reader :parent

      def initialize(params={})
        @parent = params[:parent]
      end

      def connection
        parent.connection
      end
    end
  end
end