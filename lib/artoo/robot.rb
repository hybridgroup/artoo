require 'celluloid/autostart'
require 'celluloid/io'
require 'multi_json'

require 'artoo/robot_class_methods'
require 'artoo/basic'
require 'artoo/connection'
require 'artoo/adaptors/adaptor'
require 'artoo/device'
require 'artoo/drivers/driver'
require 'artoo/events'
require 'artoo/exceptions'
require 'artoo/api/api'
require 'artoo/master'
require 'artoo/port'
require 'artoo/utility'
require 'artoo/interfaces/interface'
require 'artoo/interfaces/ping'
require 'artoo/interfaces/rover'

module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  #
  # This file contains the instance-level methods used by Artoo::Robot
  class Robot
    include Celluloid
    include Celluloid::Notifications
    extend Artoo::Basic
    extend Artoo::Robot::ClassMethods
    include Artoo::Utility
    include Artoo::Events

    attr_reader :connections, :devices, :name, :commands, :interfaces

    exclusive :execute_startup

    # Create new robot
    # @param [Hash] params
    # @option params [String]     :name
    # @option params [Collection] :connections
    # @option params [Collection] :devices
    def initialize(params={})
      @name = params[:name] || current_class.name || "Robot #{random_string}"
      @commands = params[:commands] || []
      @interfaces = {}
      initialize_connections(params[:connections] || {})
      initialize_devices(params[:devices] || {})
    end

    # @return [String] Name without spaces and downcased
    def safe_name
      name.gsub(' ', '_').downcase
    end

    # @return [String] Api Host
    def api_host
      self.class.api_host
    end

    # @return [String] Api Port
    def api_port
      self.class.api_port
    end

    # start doing the work
    def work
      Logger.info "Starting work..."
      execute_startup(connections) {|c| c.future.connect}
      execute_startup(devices) {|d| d.future.start_device}
      execute_working_code
    end

    # pause the work
    def pause_work
      Logger.info "Pausing work..."
      current_instance.timers.pause
    end

    # continue with the work
    def continue_work
      Logger.info "Continuing work..."
      current_instance.timers.continue
    end

    # Terminate all connections
    def disconnect
      connections.each {|k, c| c.async.disconnect}
    end

    # @return [Connection] default connection
    def default_connection
      connections.values.first
    end

    # @return [Collection] connection types
    def connection_types
      current_class.connection_types ||= [{:name => :passthru}]
    end

    # @return [Collection] device types
    def device_types
      current_class.device_types ||= []
      current_class.device_types
    end

    # @return [Proc] current working code
    def working_code
      current_class.working_code ||= proc {puts "No work defined."}
    end

    # @param [Symbol] period
    # @param [Numeric] interval
    # @return [Boolean] True if there is recurring work for the period and interval
    def has_work?(period, interval)
      current_instance.timers.find {|t| t.recurring == (period == :every) && t.interval == interval}
    end

    # @return [Hash] robot
    def to_hash
      {
        :name => name,
        :connections => connections.each_value.collect {|c|c.to_hash},
        :devices => devices.each_value.collect {|d|d.to_hash},
        :commands => commands
      }
    end

    # @return [JSON] robot
    def as_json
      MultiJson.dump(to_hash)
    end

    # @return [String] robot
    def inspect
      "#<Robot #{object_id}>"
    end

    # @return [Object] whatever result is passed back from the wrapped robot
    def command(method_name, *arguments, &block)
      t = interface_for_command(method_name)
      if t
        if arguments.first
          t.send(method_name, *arguments)
        else
          t.send(method_name)
        end
      else
        "Unknown Command"
      end
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
      return nil
    end

    # @return [Boolean] True if command exists
    def own_command?(method_name)
      return commands.include?(method_name.intern)
    end

    def add_interface(i)
      @interfaces[i.interface_type.intern] = i
    end

    # @return [Boolean] True if command exists in any of the robot's interfaces
    def interface_for_command(method_name)
      return self if own_command?(method_name)
      @interfaces.each_value {|i|
        return i if i.commands.include?(method_name.intern)
      }
      return nil
    end

    # Sends missing methods to command
    def method_missing(method_name, *arguments, &block)
      command(method_name, *arguments, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      own_command?(method_name)|| interface_for_command(method_name)
    end

    private


    def initialize_connections(params={})
      @connections = {}
      connection_types.each {|type| initialize_connection(params, type, @connections)}
    end

    def initialize_devices(params={})
      @devices = {}
      device_types.each {|type| initialize_device(params, type, @devices)}
    end

    def initialize_connection(params, type, connections)
      connection = initialize_object(Connection, params, type)
      @connections[type[:name]] = connection
    end

    def initialize_device(params, type, devices)
      type = initialize_object(Device, params, type)
      instance_eval("def #{type.name}; return devices[:#{type.name}]; end")
      @devices[type.name.intern] = type
    end

    def initialize_object(klass, params, type)
      Logger.info "Initializing device #{type[:name].to_s}..."
      param = params[type[:name]] || {}
      klass.new(type.merge(param).merge(:parent => current_instance))
    end

    def execute_startup(things, &block)
      future_things = things.each_value.collect {|t| yield(t)}
      future_things.each {|v| result = v.value}
    end

    def execute_working_code
      current_instance.instance_eval(&working_code)
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
    end
  end
end
