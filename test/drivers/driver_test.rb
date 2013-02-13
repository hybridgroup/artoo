require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/driver'

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
end