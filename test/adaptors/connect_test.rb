require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/adaptor'

describe Artoo::Adaptors::Adaptor do
  before do
    @adaptor = Artoo::Adaptors::Adaptor.new(:port => '1234')
  end

  it 'Artoo::Adaptors::Adaptor#connect' do
    @adaptor.connect
    @adaptor.connected?.must_equal true
  end

  it 'Artoo::Adaptors::Adaptor#disconnect' do
    @adaptor.disconnect
    @adaptor.connected?.must_equal false
  end
end