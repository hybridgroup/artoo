require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class ConnectionTestRobot < Artoo::Robot
	connection :test_connection
	device :test_device_1
  device :test_device_2
end

describe Artoo::Connection do
	before do
		@robot = ConnectionTestRobot.new
	end

  it 'Artoo::Connection#connect'
  it 'Artoo::Connection#disconnect'
end