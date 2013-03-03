require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/servo'

describe Artoo::Drivers::Servo do
  before do
    @device = mock('device')
    @device.stubs(:pin).returns(3)
    @servo = Artoo::Drivers::Servo.new(:parent => @device)

    @connection = mock('connection')
    @connection.stubs(:set_pin_mode)
    @connection.stubs(:analog_write)
    # @connection.stubs(:digital_write)
    @device.stubs(:connection).returns(@connection)
  end

  it "Servo#angle_to_span" do
    @servo.angle_to_span(0).must_equal 0
    @servo.angle_to_span(30).must_equal 42
    @servo.angle_to_span(90).must_equal 127
    @servo.angle_to_span(180).must_equal 255
  end

  it 'Servo#move must be valid' do
    invalid_angle = lambda { @servo2 = Artoo::Drivers::Servo.new(:parent => @device); @servo2.move(360) }
    invalid_angle.must_raise RuntimeError
    error = invalid_angle.call rescue $!
    error.message.must_equal 'Servo angle must be an integer between 0-180'
  end

  it 'Servo#min' do
    @servo.min
    @servo.current_angle.must_equal 0
  end

  it 'Servo#center' do
    @servo.center
    @servo.current_angle.must_equal 90
  end

  it 'Servo#max' do
    @servo.max
    @servo.current_angle.must_equal 180
  end
end