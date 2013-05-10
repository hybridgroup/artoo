require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/driver'

class Awesome < Artoo::Drivers::Driver
  COMMANDS = [:awesome].freeze
end

describe Artoo::Drivers::Driver do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Driver.new(:parent => @device)
  end

  it 'Driver#connection' do
    @connection = mock('connection')
    @device.expects(:connection).returns(@connection)
    @driver.connection.must_equal @connection
  end

  it 'Driver#pin' do
    @pin = 13
    @device.expects(:pin).returns(@pin)
    @driver.pin.must_equal @pin
  end

  it 'Driver#commands' do
    @awesome_driver = Awesome.new(:parent => @device)
    @awesome_driver.commands.first.must_equal :awesome
  end

  it 'Driver#known_command?' do
    @awesome_driver = Awesome.new(:parent => @device)
    @awesome_driver.known_command?(:awesome).must_equal true
    @awesome_driver.known_command?(:crazy).must_equal false
  end
end