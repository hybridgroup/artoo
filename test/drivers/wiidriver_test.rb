require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/wiidriver'

class Artoo::Drivers::Wiidriver
  public :set_joystick_default_value, :calculate_joystick_value, :encrypted?,
         :decode, :get_value, :generate_bool
end

describe Artoo::Drivers::Wiidriver do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Wiidriver.new(:parent => @device)
  end

  it 'Artoo::Drivers::Wiidriver#set_joystick_default_value' do
    val = "101"
    @driver.joystick[:test_axis] = nil
    @driver.set_joystick_default_value(:test_axis, val)
    @driver.joystick[:test_axis].must_equal val
  end

  it 'Artoo::Drivers::Wiidriver#calculate_joystick_value' do
    @driver.data[:test_axis] = 8
    @driver.joystick[:test_origin] = 5
    @driver.calculate_joystick_value(:test_axis, :test_origin).must_equal 3
  end

  it 'Artoo::Drivers::Wiidriver#encrypted?' do
    value = {:data => [0, 0, 0, 0, 0, 0]}
    @driver.encrypted?(value).must_equal true
  end

  it 'Artoo::Drivers::Wiidriver#encrypted?' do
    value = {:data => [1, 2, 3, 4, 5, 6]}
    @driver.encrypted?(value).must_equal false
  end

  it 'Artoo::Drivers::Wiidriver#decode' do
    @driver.decode(22).must_equal 24
    @driver.decode(0).must_equal 46
    @driver.decode(16).must_equal 30
  end

  it 'Artoo::Drivers::Wiidriver#get_value' do
    value = {:data => [1, 2, 3, 4, 5, 6], :other_data => [10, 20, 30, 40, 50, 60]}
    @driver.get_value(value, 1).must_equal 2
    @driver.get_value(value, 5).must_equal 6
  end

  it 'Artoo::Drivers::Wiidriver#generate_bool' do
    @driver.generate_bool(0).must_equal true
    @driver.generate_bool(1).must_equal false
  end
end
