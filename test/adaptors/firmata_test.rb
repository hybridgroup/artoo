require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/firmata'
require 'firmata'

describe Artoo::Adaptors::Firmata do
  before do
    @port = Artoo::Port.new('/dev/awesome')
    @adaptor = Artoo::Adaptors::Firmata.new(:port => @port)
    @firmata = mock('firmata')
    Firmata::Board.stubs(:new).returns(@firmata)
  end

  it 'Artoo::Adaptors::Firmata#connect' do
    @firmata.expects(:connect)
    @adaptor.connect.must_equal true
  end

  it 'Artoo::Adaptors::Firmata#disconnect' do
    @firmata.stubs(:connect)
    @adaptor.connect
    @adaptor.disconnect

    @adaptor.connected?.must_equal false
  end
end