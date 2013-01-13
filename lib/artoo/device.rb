module Artoo
  # The Artoo::Device class represents the interface to 
  # a specific individual hardware devices. Examples would be a digital
  # thermometer connected to an Arduino, or a Sphero's accelerometer.
  class Device
    include Celluloid
    attr_reader :parent, :name, :driver, :pin, :connection

    def initialize(params={})
      @name = params[:name].to_s
      @driver = params[:driver]
      @pin = params[:pin]
      @parent = params[:parent]
      @connection = params[:connection] || default_connection
    end

    def default_connection
      @connection = parent.default_connection
    end
  end
end