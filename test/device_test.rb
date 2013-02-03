require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DeviceTestRobot < Artoo::Robot
  connection :test_connection
  device :test_device_1
  device :test_device_2
end

class MultipleDeviceConnectionTestRobot < Artoo::Robot
  connection :test_connection
  connection :test_connection2
  device :test_device_1, :connection => :test_connection
  device :test_device_2, :connection => :test_connection2
end

describe Artoo::Device do
  before do
    @robot = DeviceTestRobot.new
  end

  it 'Artoo::Device#default_connection' do
    @robot.devices[:test_device_1].default_connection.must_equal @robot.default_connection
    @robot.devices[:test_device_2].default_connection.must_equal @robot.default_connection
  end

  it 'Artoo::Device#connect' do
    @robot2 = MultipleDeviceConnectionTestRobot.new
    @robot2.devices[:test_device_1].connection.must_equal @robot2.connections[:test_connection]
    @robot2.devices[:test_device_2].connection.must_equal @robot2.connections[:test_connection2]
  end
end