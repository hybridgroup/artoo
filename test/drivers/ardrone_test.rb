require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/ardrone'

describe Artoo::Drivers::Ardrone do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::Ardrone.new(:parent => @device)
  end

  it 'must do things'
end