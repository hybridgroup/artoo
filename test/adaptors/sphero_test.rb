require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/sphero'
require 'sphero'

describe Artoo::Adaptors::Sphero do
  before do
    @port = Artoo::Port.new('/dev/awesome')
    @adaptor = Artoo::Adaptors::Sphero.new(:port => @port)
    @sphero = mock('sphero')
    Sphero.stubs(:new).returns(@sphero)
  end

  it 'Artoo::Adaptors::Sphero#connect' do
    @adaptor.connect.must_equal true
  end

  it 'Artoo::Adaptors::Sphero#disconnect' do
    @adaptor.connect

    @sphero.expects(:close)
    @adaptor.disconnect
    @adaptor.connected?.must_equal false
  end
end