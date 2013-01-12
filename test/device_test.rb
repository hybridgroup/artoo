require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DeviceTestRobot < Artoo::Robot
  connection :test_connection
  device :test_device_1
  device :test_device_2
end

describe Artoo::Device do
  before do
    @robot = DeviceTestRobot.new
  end

  it 'Artoo::Device#default_connection' do
    @robot.devices.first.default_connection.must_equal @robot.default_connection
    @robot.devices.last.default_connection.must_equal @robot.default_connection
  end
end