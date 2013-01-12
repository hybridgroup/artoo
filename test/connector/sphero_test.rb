require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/connector/sphero'

class SpheroConnectorRobot < Artoo::Robot
	connection :test_connection
	device :test_device_1
  device :test_device_2
end

describe Artoo::Connector::Sphero do
	before do
		@robot = SpheroConnectorRobot.new
	end

  it 'Artoo::Connector::Sphero#connect'
  it 'Artoo::Connector::Sphero#disconnect'
end