require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/connector/connect'

describe Artoo::Connector::Connect do
	before do
		@connector = Artoo::Connector::Connect.new(:port => '1234')
	end

  it 'Artoo::Connector::Connect#connect' do
  	@connector.connect
  	@connector.connected?.must_equal true
  end

  it 'Artoo::Connector::Connect#disconnect' do
		@connector.disconnect
  	@connector.connected?.must_equal false
  end
end