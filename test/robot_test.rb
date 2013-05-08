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

  it 'Artoo::Robot#safe_name' do
    robotina = TestRobot.new(:name => "I Am A Robot")
    robotina.safe_name.must_equal 'i_am_a_robot'
  end

  it 'Artoo::Robot#name random when not provided' do
    TestRobot.any_instance.stubs(:random_string).returns("RANDOM")
    @robot3 = TestRobot.new(:connections => {:test_connection => {:port => '1234'}})
    @robot3.name.must_equal 'Robot RANDOM'
  end

  it 'Artoo::Robot#connections' do
    @robot.connections[:test_connection].name.must_equal 'test_connection'
  end

  it 'Artoo::Robot#default_connection' do
    @robot.default_connection.name.must_equal 'test_connection'
  end

  it 'Artoo::Robot#connections initialized with params' do
    @robot.connections[:test_connection].port.host.must_equal 'localhost'
    @robot.connections[:test_connection].port.port.must_equal '1234'
  end

  it 'Artoo::Robot#devices' do
    @robot.devices[:test_device].name.must_equal 'test_device'
  end

  it 'Artoo::Robot#test_device' do
    @robot.test_device.name.must_equal 'test_device'
    @robot.another_test_device.name.must_equal 'another_test_device'
  end

  it 'connects to Artoo::Adaptors::Loopback' do
    @robot.default_connection.adaptor.must_be_kind_of Artoo::Adaptors::Loopback
  end

  it 'Artoo::Robot.work! with single object' do
    TestRobot.stubs(:sleep)

    TestRobot.expects(:start_work)
    TestRobot.work!(@robot)
  end

  it 'Artoo::Robot.work! with array of objects' do
    @robot2 = TestRobot.new(:name => "too", :connections => {:test_connection => {:port => '1234'}})
    TestRobot.stubs(:sleep)

    TestRobot.expects(:start_work)
    TestRobot.work!([@robot, @robot2])
  end

  it 'Artoo::Robot.work! without object' do
    TestRobot.stubs(:sleep)

    TestRobot.expects(:start_work)
    TestRobot.work!
  end

  it 'Artoo::Robot#as_json' do
    MultiJson.load(@robot.as_json, :symbolize_keys => true)[:name].must_equal "testme"
  end
end