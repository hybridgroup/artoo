require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class TestRobot < Artoo::Robot
  connection :test_connection
  device :test_device
  device :another_test_device
end

describe Artoo::Robot do
  before do
    @robot = TestRobot.new(:name => "testme", :connections => {:test_connection => {:port => '1234'}})
  end

  it 'Artoo::Robot.connection_types' do
    @robot.connection_types.first[:name].must_equal :test_connection
  end

  it 'Artoo::Robot.device_types' do
    @robot.device_types.first[:name].must_equal :test_device
  end

  it 'Artoo::Robot#name' do
    @robot.name.must_equal 'testme'
  end

  it 'Artoo::Robot#connections' do
    @robot.connections[:test_connection].name.must_equal 'test_connection'
  end

  it 'Artoo::Robot#default_connection' do
    @robot.default_connection.name.must_equal 'test_connection'
  end

  it 'Artoo::Robot#connections initialized with params' do
    @robot.connections[:test_connection].port.must_equal '1234'
  end

  it 'Artoo::Robot#devices' do
    @robot.devices[:test_device].name.must_equal 'test_device'
  end

  it 'Artoo::Robot#test_device' do
    @robot.test_device.name.must_equal 'test_device'
    @robot.another_test_device.name.must_equal 'another_test_device'
  end

  it 'connects to Artoo::Connector::Loopback' do
    @robot.default_connection.connector.must_be_kind_of Artoo::Connector::Loopback
  end

  it 'Artoo::Robot.work! with single object' do
    TestRobot.stubs(:sleep)

    @asm = mock("async_method")
    @asm.expects(:work)
    @robot.expects(:async).returns(@asm)
    TestRobot.work!(@robot)
  end

  it 'Artoo::Robot.work! with array of objects' do
    @robot2 = TestRobot.new(:name => "too", :connections => {:test_connection => {:port => '1234'}})
    TestRobot.stubs(:sleep)

    @asm = mock("async_method")
    @asm.expects(:work).times(2)
    @robot.expects(:async).returns(@asm)
    @robot2.expects(:async).returns(@asm)
    TestRobot.work!([@robot, @robot2])
  end

  it 'Artoo::Robot.work! without object' do
    TestRobot.stubs(:sleep)

    @asm = mock("async_method")
    @asm.expects(:work).at_least_once
    TestRobot.expects(:new).returns(@robot)
    @robot.expects(:async).returns(@asm)
    TestRobot.work!
  end
end