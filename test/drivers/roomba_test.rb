require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/roomba'

describe Artoo::Drivers::Roomba do
  before do
    @connection = mock('connection')
    @device = mock('device')
    @device.stubs(:connection).returns(@connection)
    @roomba = Artoo::Drivers::Roomba.new(:parent => @device)
    @roomba.stubs(:sleep)
  end

  it 'Roomba#start' do
    @connection.expects(:send_bytes).with(Artoo::Drivers::Roomba::Mode::START)
    @roomba.start
  end

  it 'Roomba#safe_mode' do
    @roomba.stubs(:start)
    @connection.expects(:send_bytes).with(Artoo::Drivers::Roomba::Mode::SAFE)
    @roomba.safe_mode
  end

  it 'Roomba#full_mode' do
    @roomba.stubs(:start)
    @connection.expects(:send_bytes).with(Artoo::Drivers::Roomba::Mode::FULL)
    @roomba.full_mode
  end

  it 'Roomba#forward' do
    @roomba.wrapped_object.expects(:drive).with(250, Artoo::Drivers::Roomba::Direction::STRAIGHT, 10)
    @roomba.wrapped_object.expects(:stop)
    @roomba.forward(10, 250)
  end

  it 'Roomba#stop' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::ZERO, Artoo::Drivers::Roomba::Direction::STRAIGHT)
    @roomba.stop
  end

  it 'Roomba#fast_forward' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::MAX, Artoo::Drivers::Roomba::Direction::STRAIGHT, 10)
    @roomba.wrapped_object.expects(:stop)
    @roomba.fast_forward(10)
  end

  it 'Roomba#backwards' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::NEG, Artoo::Drivers::Roomba::Direction::STRAIGHT, 10)
    @roomba.wrapped_object.expects(:stop)
    @roomba.backwards(10)
  end

  it 'Roomba#turn_left' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::SLOW, Artoo::Drivers::Roomba::Direction::COUNTERCLOCKWISE, 10)
    @roomba.wrapped_object.expects(:stop)
    @roomba.turn_left(10)
  end

  it 'Roomba#nudge_left' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::SLOW, Artoo::Drivers::Roomba::Direction::COUNTERCLOCKWISE, 0.25)
    @roomba.wrapped_object.expects(:stop)
    @roomba.nudge_left
  end

  it 'Roomba#turn_right' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::SLOW, Artoo::Drivers::Roomba::Direction::CLOCKWISE, 10)
    @roomba.wrapped_object.expects(:stop)
    @roomba.turn_right(10)
  end

  it 'Roomba#nudge_right' do
    @roomba.wrapped_object.expects(:drive).with(Artoo::Drivers::Roomba::Speed::SLOW, Artoo::Drivers::Roomba::Direction::CLOCKWISE, 0.25)
    @roomba.wrapped_object.expects(:stop)
    @roomba.nudge_right
  end
end