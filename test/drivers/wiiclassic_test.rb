require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/wiiclassic'

describe Artoo::Drivers::Wiiclassic do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Wiiclassic.new(:parent => @device)
  end

  it 'must do things'
end
