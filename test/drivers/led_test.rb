require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/led'

describe Artoo::Drivers::Led do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Led.new(:parent => @device)
    @connection = mock('connection')
    #@device.expects(:connection).returns(@connection)
  end

  it 'Led#on'
  it 'Led#off'
end