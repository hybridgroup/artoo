require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/connector/ardrone'

class ArdroneConnectorRobot < Artoo::Robot
  connection :test_connection, :type => :ardrone
end

describe Artoo::Connector::Ardrone do
  before do
    @robot = ArdroneConnectorRobot.new
  end

  it 'connects to Artoo::Connector::Ardrone' do
		@robot.default_connection.connector.must_be_kind_of Artoo::Connector::Ardrone
  end

  it 'Artoo::Connector::Ardrone#connect'
  it 'Artoo::Connector::Ardrone#disconnect'
end