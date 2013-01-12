require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/connector/loopback'

class LoopbackConnectorRobot < Artoo::Robot
	connection :test_connection
	device :test_device_1
  device :test_device_2
end

describe Artoo::Connector::Loopback do
	before do
		@robot = LoopbackConnectorRobot.new
	end

  it 'Artoo::Connector::Loopback#connect'
  it 'Artoo::Connector::Loopback#disconnect'
end