require 'celluloid'

require 'artoo/connection'
require 'artoo/device'
require 'artoo/utility'

module Artoo
  # The most important class used by Artoo is Robot. This represents the primary
  # interface for interacting with a collection of physical computing capabilities.
  class Robot
    include Celluloid
    attr_reader :connections, :devices, :name

    def initialize(params={})
      @name = params[:name] || "Robot"
      initialize_connections(params[:connections] || {})
      initialize_devices(params[:devices] || {})
    end
    
    class << self
      attr_accessor :connection_types, :device_types, :working_code
      
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
      # Example:
      #   work do 
      #     every(10.seconds) do
      #       puts "hello, world"
      #     end
      #   end
      def work(&block)
        Celluloid::Logger.info "Preparing work..."
        self.working_code = block if block_given?
      end

      def work!(val=nil)
        if val.respond_to?(:work)
          val.async.work
        elsif val.kind_of?(Array)
          val.each {|r| r.async.work}
        else
          self.new.async.work
        end
        sleep # sleep main thread, and let the work commence!
      end

      def test?
        ENV["ARTOO_TEST"] == 'true'
      end

      # Taken from Sinatra codebase
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

      # Taken from Sinatra codebase
      CALLERS_TO_IGNORE = [ # :nodoc:
        /lib\/artoo.*\.rb$/,                             # artoo code
        /^\(.*\)$/,                                      # generated code
        /rubygems\/custom_require\.rb$/,                 # rubygems require hacks
        /active_support/,                                # active_support require hacks
        /bundler(\/runtime)?\.rb/,                       # bundler require hacks
        /<internal:/,                                    # internal in ruby >= 1.9.2
        /src\/kernel\/bootstrap\/[A-Z]/                  # maglev kernel files
      ]

      # Taken from Sinatra codebase
      # Like Kernel#caller but excluding certain magic entries and without
      # line / method information; the resulting array contains filenames only.
      def caller_files
        cleaned_caller(1).flatten
      end

      private

      # Taken from Sinatra codebase
      def define_singleton_method(name, content = Proc.new)
      # replace with call to singleton_class once we're 1.9 only
        (class << self; self; end).class_eval do
          undef_method(name) if method_defined? name
          String === content ? class_eval("def #{name}() #{content}; end") : define_method(name, &content)
        end
      end

      # Taken from Sinatra codebase
      # Like Kernel#caller but excluding certain magic entries
      def cleaned_caller(keep = 3)
        caller(1).
          map    { |line| line.split(/:(?=\d|in )/, 3)[0,keep] }.
          reject { |file, *_| CALLERS_TO_IGNORE.any? { |pattern| file =~ pattern } }
      end
    end

    # start doing the work
    def work
      Logger.info "Starting work..."
      connect
      current_instance.instance_eval(&working_code)
    rescue Exception => e
      Logger.error e.message
      Logger.error e.backtrace.inspect
    end

    def connect
      result = false
      future_connections = []
      # block until all connections done
      connections.each {|k, c| future_connections << c.future.connect}
      future_connections.each {|v| result = v.value}
      result
    end

    def disconnect
      connections.each {|k, c| c.async.disconnect}
    end

    def default_connection
      connections[connections.keys.first]
    end

    def connection_types
      current_class.connection_types ||= []
      current_class.connection_types
    end

    def device_types
      current_class.device_types ||= []
      current_class.device_types
    end

    def working_code
      current_class.working_code ||= proc {puts "No work defined."}
    end
    
    private

    def initialize_connections(params={})
      @connections = {}
      connection_types.each {|ct|
        Logger.info "Initializing connection #{ct[:name].to_s}..."
        cp = params[ct[:name]] || {}
        c = Connection.new(ct.merge(cp).merge(:parent => Actor.current))
        @connections[ct[:name]] = c
      }
    end

    def initialize_devices(params={})
      @devices = {}
      device_types.each {|d|
        Logger.info "Initializing device #{d[:name].to_s}..."
        d = Device.new(d.merge(:parent => Actor.current))
        instance_eval("def #{d.name}; return devices[:#{d.name}]; end")
        @devices[d.name.intern] = d
      }
    end

    def current_instance
      Actor.current
    end

    def current_class
      Actor.current.class
    end
  end
end