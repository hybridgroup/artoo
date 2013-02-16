module Artoo
  # The Artoo::Device class represents the interface to 
  # a specific individual hardware devices. Examples would be a digital
  # thermometer connected to an Arduino, or a Sphero's accelerometer.
  class Device
    include Celluloid
    include Artoo::Utility
    
    attr_reader :parent, :name, :driver, :pin, :connection, :interval

    def initialize(params={})
      @name = params[:name].to_s
      @pin = params[:pin]
      @parent = params[:parent]
      @connection = determine_connection(params[:connection]) || default_connection
      @interval = params[:interval] || 0.5

      require_driver(params[:driver] || :passthru)
    end

    def determine_connection(c)
      parent.connections[c] unless c.nil?
    end

    def default_connection
      parent.default_connection
    end

    def start
      driver.start  
    end

    def method_missing(method_name, *arguments, &block)
      driver.send(method_name, *arguments, &block)
    end

    private

    def require_driver(d)
      require "artoo/drivers/#{d.to_s}"
      @driver = constantize("Artoo::Drivers::#{d.to_s.capitalize}").new(:parent => current_instance)
    end
  end
end