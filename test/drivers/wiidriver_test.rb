require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/wiidriver'

class Artoo::Drivers::Wiidriver
  public :set_joystick_default_value, :calculate_joystick_value, :encrypted?,
         :decode, :generate_bool
end

describe Artoo::Drivers::Wiidriver do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Wiidriver.new(:parent => @device)
  end

  it 'must Artoo::Drivers::Wiidriver#set_joystick_default_value' do
    val = "101"
    @driver.joystick[:test_axis] = nil
    @driver.set_joystick_default_value(:test_axis, val)
    @driver.joystick[:test_axis].must_equal val
  end

  it 'must Artoo::Drivers::Wiidriver#calculate_joystick_value' do
    @driver.data[:test_axis] = 8
    @driver.joystick[:test_origin] = 5
    @driver.calculate_joystick_value(:test_axis, :test_origin).must_equal 3
  end

  it 'must Artoo::Drivers::Wiidriver#encrypted?' do
    value = {:data => [0, 0, 0, 0, 0, 0]}
    @driver.encrypted?(value).must_equal true
  end

  it 'must Artoo::Drivers::Wiidriver#decode' do
    @driver.decode(22).must_equal 24
    @driver.decode(0).must_equal 46
    @driver.decode(16).must_equal 30
  end

  it 'must Artoo::Drivers::Wiidriver#generate_bool' do
    @driver.generate_bool(0).must_equal true
    @driver.generate_bool(1).must_equal false
  end
end
