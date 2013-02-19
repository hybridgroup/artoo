require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/wiichuck'

describe Artoo::Drivers::Wiichuck do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Wiichuck.new(:parent => @device)
  end

  it 'must do things'
end
