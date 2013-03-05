require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/wiiclassic'

describe Artoo::Drivers::Wiiclassic do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Wiiclassic.new(:parent => @device)
  end

  it 'must Artoo::Drivers::Wiiclassic#set_joystick_default_value' do
    val = "101"
    @driver.joystick[:test_axis] = nil
    @driver.set_joystick_default_value(:test_axis, val)
    @driver.joystick[:test_axis].must_equal val
  end
end
