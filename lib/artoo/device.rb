module Artoo
  # The Artoo::Device class represents the interface to 
  # a specific individual hardware devices. Examples would be a digital
  # thermometer connected to an Arduino, or a Sphero's accelerometer.
  class Device
    include Celluloid
    attr_reader :parent, :name, :driver, :pin, :connection

    def initialize(params={})
      @name = params[:name].to_s
      @driver = params[:driver] || :passthru
      @pin = params[:pin]
      @parent = params[:parent]
      @connection = connect(params[:connection]) || default_connection

      require_driver
    end

    def method_missing(method_name, *arguments, &block)
      connection.send(method_name, *arguments, &block)
    end

    def connect(c)
      parent.connections[c] unless c.nil?
    end

    def default_connection
      parent.default_connection
    end

    private

    def require_driver
      require "artoo/drivers/#{driver.to_s}"
      @driver = constantize("Artoo::Drivers::#{driver.to_s.capitalize}").new(:parent => Actor.current)
    end
  end
end