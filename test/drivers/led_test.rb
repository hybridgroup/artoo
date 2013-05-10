require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/led'

describe Artoo::Drivers::Led do
  before do
    @device = mock('device')
    @pin = 13
    @device.stubs(:pin).returns(@pin)
    @led = Artoo::Drivers::Led.new(:parent => @device)
    @connection = mock('connection')
    @device.stubs(:connection).returns(@connection)
  end

  it 'Led#is_on? default' do
    @led.is_on?.must_equal false
  end

  it 'Led#is_off? default' do
    @led.is_off?.must_equal true
  end

  it 'Led#on' do
    @connection.expects(:set_pin_mode).with(@pin, Firmata::Board::OUTPUT)
    @connection.expects(:digital_write).with(@pin, Firmata::Board::HIGH)
    @led.on
    @led.is_on?.must_equal true
  end

  it 'Led#off' do
    @connection.expects(:set_pin_mode).with(@pin, Firmata::Board::OUTPUT)
    @connection.expects(:digital_write).with(@pin, Firmata::Board::LOW)
    @led.off
    @led.is_off?.must_equal true
  end

  it 'Led#toggle' do
    @connection.stubs(:set_pin_mode)
    @connection.stubs(:digital_write)
    @led.is_off?.must_equal true
    @led.toggle
    @led.is_on?.must_equal true
    @led.toggle
    @led.is_off?.must_equal true
  end

  it 'Led#brightness' do
    val = 100
    @connection.expects(:set_pin_mode).with(@pin, Firmata::Board::PWM)
    @connection.expects(:analog_write).with(@pin, val)
    @led.brightness(val)
  end

  it 'Led#commands' do
    @led.commands.must_include :toggle
  end
end