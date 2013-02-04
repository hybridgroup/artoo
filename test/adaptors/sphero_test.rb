require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/sphero'

class SpheroConnectorRobot < Artoo::Robot
  connection :test_connection
  device :test_device_1
  device :test_device_2
end

describe Artoo::Adaptors::Sphero do
  before do
    @robot = SpheroConnectorRobot.new
  end

  it 'Artoo::Adaptors::Sphero#connect'
  it 'Artoo::Adaptors::Sphero#disconnect'
end