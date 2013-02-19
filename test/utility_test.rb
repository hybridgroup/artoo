require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class UtilityTestRobot < Artoo::Robot
  connection :test_connection
  device :test_device_1
  device :test_device_2
end

describe Artoo::Utility do
  before do
    @robot = UtilityTestRobot.new
  end

  it 'Artoo::Utility#random_string' do
    string = @robot.random_string
    string.must_be_kind_of String
    string.size.must_equal 8
  end

  it 'Artoo::Utility#classify' do
    string = @robot.classify('firmata')
    string.must_equal 'Firmata'

    string = @robot.classify('ardrone_awesome')
    string.must_equal 'ArdroneAwesome'
  end
end