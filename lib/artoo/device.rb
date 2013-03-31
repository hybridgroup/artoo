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

    def start_device
      driver.start_driver
    end

    def event_topic_name(event)
      "#{parent.safe_name}_#{name}_#{event}"  
    end

    def to_hash
      {:name => name,
       :driver => driver.class.name.demodulize,
       :pin => pin.to_s,
       :connection => connection.to_hash,
       :interval => interval
      }
    end

    def as_json
      MultiJson.dump(to_hash)
    end

    def method_missing(method_name, *arguments, &block)
      driver.send(method_name, *arguments, &block)
    end

    def inspect
      "#<Device @id=#{object_id}, @name='name', @driver='driver'>"
    end

    private

    def require_driver(d)
      require "artoo/drivers/#{d.to_s}"
      @driver = constantize("Artoo::Drivers::#{classify(d.to_s)}").new(:parent => current_instance)
    end
  end
end