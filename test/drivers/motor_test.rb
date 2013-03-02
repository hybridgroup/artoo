require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/motor'

describe Artoo::Drivers::Motor do
  before do
    @device = mock('device')
    @device.stubs(:pin).returns([2, 3, 4])
    @motor = Artoo::Drivers::Motor.new(:parent => @device)

    @connection = mock('connection')
    @connection.stubs(:set_pin_mode)
    @connection.stubs(:analog_write)
    @connection.stubs(:digital_write)
    @device.stubs(:connection).returns(@connection)
  end

  it 'Motor#speed must be valid' do
    invalid_speed = lambda { @motor2 = Artoo::Drivers::Motor.new(:parent => @device); @motor2.speed("ads") }
    invalid_speed.must_raise RuntimeError
    error = invalid_speed.call rescue $!
    error.message.must_equal 'Motor speed must be an integer between 0-255'
  end

  it 'Motor#forward' do
    @motor.wrapped_object.expects(:set_legs)
    @motor.forward(100)
    @motor.current_speed.must_equal 100
  end

  it 'Motor#backward' do
    @motor.wrapped_object.expects(:set_legs)
    @motor.backward(100)
    @motor.current_speed.must_equal 100
  end

  it 'Motor#stop' do
    @motor.stop
    @motor.current_speed.must_equal 0
  end
end