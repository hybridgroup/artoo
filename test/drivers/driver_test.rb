require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/driver'

describe Artoo::Drivers::Driver do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Driver.new(:parent => @device)
  end

  it 'Artoo::Drivers::Driver'
end