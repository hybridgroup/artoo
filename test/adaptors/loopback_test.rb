require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/loopback'

describe Artoo::Adaptors::Loopback do
  before do
    @adaptor = Artoo::Adaptors::Loopback.new(:port => '1234')
  end

  it 'Artoo::Adaptors::Loopback#connect' do
    @adaptor.connect
    @adaptor.connected?.must_equal true
  end

  it 'Artoo::Adaptors::Loopback#disconnect' do
    @adaptor.disconnect
    @adaptor.connected?.must_equal false
  end
end