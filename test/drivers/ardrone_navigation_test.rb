require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/ardrone_navigation'

describe Artoo::Drivers::ArdroneNavigation do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::ArdroneNavigation.new(:parent => @device)
  end

  it 'must do things'
end