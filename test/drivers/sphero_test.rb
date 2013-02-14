require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/sphero'

describe Artoo::Drivers::Sphero do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Sphero.new(:parent => @device)
    @connection = mock('connection')
    @col1 = ::Sphero::Response::CollisionDetected.new("yo", "ho")
    @col2 = ::Sphero::Response::CollisionDetected.new("yo", "ho")
    @sen1 = ::Sphero::Response::SensorData.new("yo", "ho")
    @sen2 = ::Sphero::Response::SensorData.new("lo", "no")
    @sen3 = ::Sphero::Response::SensorData.new("jo", "jo")
    @pow1 = ::Sphero::Response::PowerNotification.new("yo", "ho")
    @pow2 = ::Sphero::Response::PowerNotification.new("yo", "ho")
    @connection.expects(:async_messages).returns([@col1, @col2, @sen1, @sen2, @sen3, @pow1, @pow2])
    @device.expects(:connection).returns(@connection)
  end

  it 'Sphero#collisions' do
    @driver.collisions.size.must_equal 2
  end

  it 'Sphero#power_notifications' do
    @driver.power_notifications.size.must_equal 2
  end

  it 'Sphero#sensor_data' do
    @driver.sensor_data.size.must_equal 3
  end
end