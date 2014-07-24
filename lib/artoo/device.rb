module Artoo
  # The Artoo::Device class represents the interface to
  # a specific individual hardware devices. Examples would be a digital
  # thermometer connected to an Arduino, or a Sphero's accelerometer.
  class Device
    include Celluloid
    include Artoo::Utility

    attr_reader :parent, :name, :driver, :pin, :connection, :interval, :interface

    # Create new device
    # @param  [Hash] params
    # @option params :name       [String]
    # @option params :pin        [String]
    # @option params :parent     [String]
    # @option params :connection [String]
    # @option params :interval   [String]
    # @option params :driver     [String]
    def initialize(params={})
      @name = params[:name].to_s
      @pin = params[:pin]
      @parent = params[:parent]
      @connection = determine_connection(params[:connection]) || default_connection
      @interval = params[:interval] || 0.5

      require_driver(params[:driver] || :passthru, params)
    end

    # Retrieve connections from parent
    # @param [String] c connection
    def determine_connection(c)
      parent.connections[c] unless c.nil?
    end

    # @return [Connection] default connection
    def default_connection
      parent.default_connection
    end

    # Starts device driver
    def start_device
      driver.start_driver
    end

    # @return [String] event topic name
    def event_topic_name(event)
      "#{parent.safe_name}_#{name}_#{event}"
    end

    def publish(event, *data)
      if data.first
        driver.publish(event_topic_name(event), *data)
      else
        driver.publish(event_topic_name(event))
      end
    end

    # @return [Hash] device
    def to_hash
      {
        :name => name,
        :driver => driver.class.name.to_s.gsub(/^.*::/, ''),
        :pin => pin.to_s,
        :connection => connection.to_hash,
        :interval => interval,
        :commands => driver.commands
      }
    end

    # @return [JSON] device
    def as_json
      MultiJson.dump(to_hash)
    end

    # @return [Collection] commands
    def commands
      driver.commands
    end

    # Execute driver command
    def command(method_name, *arguments, &block)
      driver.command(method_name, *arguments)
    end

    # Sends missing methods to command
    def method_missing(method_name, *arguments, &block)
      command(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      commands.include?(method_name) || super
    end

    # @return [String] pretty inspect
    def inspect
      "#<Device @id=#{object_id}, @name='name', @driver='#{driver.class.name}'>"
    end

    def add_interface(i)
      @parent.add_interface(i)  
    end

    def require_interface(i)
      Logger.info "Require interface #{i}"
      require "artoo/interfaces/#{i.to_s}"
      @interface = constantize("Artoo::Interfaces::#{classify(i.to_s)}").new(:name => i.to_s, :robot => parent, :device => current_instance)      
      add_interface(@interface)
    end

    private

    def require_driver(d, params)
      if Artoo::Robot.test?
        original_type = d
        d = :test
      end

      require "artoo/drivers/#{d.to_s}"
      @driver = constantize("Artoo::Drivers::#{classify(d.to_s)}").new(:parent => current_instance, :additional_params => params)
    end
  end
end
