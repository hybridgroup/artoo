require 'celluloid'

require 'artoo/connection'
require 'artoo/device'
require 'artoo/utility'

module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  class Robot
    include Celluloid
    attr_reader :connections, :devices

    def initialize
      initialize_connections
      initialize_devices
    end
    
    class << self
      attr_accessor :connection_types, :device_types, :working_code

      # Sets an option to the given value.  If the value is a proc,
      # the proc will be called every time the option is accessed.
      def set(option, value = (not_set = true), ignore_setter = false, &block)
        raise ArgumentError if block and !not_set
        value, not_set = block, false if block

        if not_set
          raise ArgumentError unless option.respond_to?(:each)
          option.each { |k,v| set(k, v) }
          return self
        end

        if respond_to?("#{option}=") and not ignore_setter
          return __send__("#{option}=", value)
        end

        setter = proc { |val| set option, val, true }
        getter = proc { value }

        case value
        when Proc
          getter = value
        when Symbol, Fixnum, FalseClass, TrueClass, NilClass
          getter = value.inspect
        when Hash
          setter = proc do |val|
            val = value.merge val if Hash === val
            set option, val, true
          end
        end

        define_singleton_method("#{option}=", setter) if setter
        define_singleton_method(option, getter) if getter
        define_singleton_method("#{option}?", "!!#{option}") unless method_defined? "#{option}?"
        self
      end

      def define_singleton_method(name, content = Proc.new)
      # replace with call to singleton_class once we're 1.9 only
        (class << self; self; end).class_eval do
          undef_method(name) if method_defined? name
          String === content ? class_eval("def #{name}() #{content}; end") : define_method(name, &content)
        end
      end

      # connection to some hardware that has one or more devices via some specific protocol
      # Example:
      #   connection :arduino, :type => :firmata, :port => '/dev/tty.usbmodemxxxxx'
      def connection(name, params = {})
        Celluloid::Logger.info "Registering connection '#{name}'..."
        self.connection_types ||= []
        self.connection_types << {:name => name}.merge(params)
      end

      # device that uses a connection to communicate
      # Example:
      #   device :collision_detect, :driver => :switch, :pin => 3
      def device(name, params = {})
        Celluloid::Logger.info "Registering device '#{name}'..."
        self.device_types ||= []
        self.device_types << {:name => name}.merge(params)
      end

      # the work that needs to be performed
      def work(&block)
        Celluloid::Logger.info "Preparing work..."
        self.working_code = block if block_given?
      end

      def test?
        ENV["ARTOO_TEST"] == 'true'
      end
    end

    # start doing the work
    def work
      Logger.info "Starting work..."
      Actor.current.instance_eval(&working_code)
    rescue Exception => e  
      Logger.info e.message  
      Logger.info e.backtrace.inspect    
    end

    def default_connection
      connections.first
    end

    def connection_types
      Actor.current.class.connection_types ||= []
      Actor.current.class.connection_types
    end

    def device_types
      Actor.current.class.device_types ||= []
      Actor.current.class.device_types
    end

    def working_code
      Actor.current.class.working_code ||= proc {puts "No work defined."} 
    end
    
    private

    def initialize_connections
      @connections = []
      connection_types.each {|c|
        Logger.info "Initializing connection #{c[:name].to_s}..."
        @connections << Connection.new(c.merge(:parent => Actor.current))
      }
    end

    def initialize_devices
      @devices = []
      device_types.each {|d|
        Logger.info "Initializing device #{d[:name].to_s}..."
        @devices << Device.new(d.merge(:parent => Actor.current))
      }
    end
  end
end