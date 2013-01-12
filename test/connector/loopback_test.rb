require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/connector/loopback'

describe Artoo::Connector::Loopback do
  before do
    @connector = Artoo::Connector::Loopback.new(:port => '1234')
  end

  it 'Artoo::Connector::Loopback#connect' do
    @connector.connect
    @connector.connected?.must_equal true
  end

  it 'Artoo::Connector::Loopback#disconnect' do
    @connector.disconnect
    @connector.connected?.must_equal false
  end
end