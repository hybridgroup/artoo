require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/ardrone'

class ArdroneConnectorRobot < Artoo::Robot
  connection :test_connection, :adaptor => :ardrone
end

describe Artoo::Adaptors::Ardrone do
  before do
    @robot = ArdroneConnectorRobot.new
  end

  it 'connects to Artoo::Adaptors::Ardrone' do
		@robot.default_connection.adaptor.must_be_kind_of Artoo::Adaptors::Ardrone
  end

  it 'Artoo::Adaptors::Ardrone#connect'
  it 'Artoo::Adaptors::Ardrone#disconnect'
end