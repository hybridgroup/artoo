require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/firmata'

class FirmataConnectorRobot < Artoo::Robot
  connection :test_connection, :type => :firmata
end

describe Artoo::Adaptors::Firmata do
  before do
    @robot = FirmataConnectorRobot.new
  end

  it 'Artoo::Adaptors::Firmata#connect'
  it 'Artoo::Adaptors::Firmata#disconnect'
end