require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/connector/ardrone'

class ArdroneConnectorRobot < Artoo::Robot
	connection :test_connection
	device :test_device_1
  device :test_device_2
end

describe Artoo::Connector::Ardrone do
	before do
		@robot = ArdroneConnectorRobot.new
	end

  it 'Artoo::Connector::Ardrone#connect'
  it 'Artoo::Connector::Ardrone#disconnect'
end