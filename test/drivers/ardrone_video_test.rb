require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/ardrone_video'

describe Artoo::Drivers::ArdroneVideo do
  before do
    @device = mock('device')
    @driver = Artoo::Drivers::ArdroneVideo.new(:parent => @device)
  end

  it 'must do things'
end