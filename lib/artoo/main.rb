module Artoo
  # Execution context for top-level robots
  # DSL methods executed on main are delegated to this class like Sinatra
  class MainRobot < Robot
    #set :logging, Proc.new { ! test? }
    #set :method_override, true
    #set :run, Proc.new { ! test? }
    #set :app_file, nil

    def self.register(*extensions, &block) #:nodoc:
      added_methods = extensions.map {|m| m.public_instance_methods }.flatten
      Delegator.delegate(*added_methods)
      super(*extensions, &block)
    end
  end
  
  # Artoo delegation mixin that acts like Sinatra. 
  # Mixing this module into an object causes all
  # methods to be delegated to the Artoo::MainRobot class. 
  # Used primarily at the top-level.
  module Delegator #:nodoc:
    def self.delegate(*methods)
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          return super(*args, &block) if respond_to? method_name
          Delegator.target.send(method_name, *args, &block)
        end
        private method_name
      end
    end

    delegate :connection, :device, :work

    class << self
      attr_accessor :target
    end

    self.target = MainRobot
  end

  # Create a new Artoo robot. The block is evaluated
  # in the new robot's class scope.
  def self.new(robot=Robot, options={}, &block)
    robot = Class.new(robot)
    robot.class_eval(&block) if block_given?
    robot
  end
end