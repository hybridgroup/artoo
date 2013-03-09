require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/wiidriver'

describe Artoo::Drivers::Wiidriver do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Wiidriver.new(:parent => @device)
  end

  it 'must do things'
end
