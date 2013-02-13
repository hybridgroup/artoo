require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/ardrone'
require 'argus'

describe Artoo::Adaptors::Ardrone do
  before do
    @port = Artoo::Port.new('/dev/awesome')
    @adaptor = Artoo::Adaptors::Ardrone.new(:port => @port)
    @ardrone = mock('ardrone')
    Argus::Drone.stubs(:new).returns(@ardrone)
  end

  it 'Artoo::Adaptors::Ardrone#connect' do
    @adaptor.connect.must_equal true
  end

  it 'Artoo::Adaptors::Ardrone#disconnect' do
    @adaptor.connect

    @ardrone.expects(:stop)
    @adaptor.disconnect
    @adaptor.connected?.must_equal false
  end
end