require File.expand_path(File.dirname(__FILE__) + "/test_helper")

describe Artoo do
  it 'must create a new Artoo::Robot subclass on new' do
    robot = Artoo.new { work { puts 'Hello World' } }
    robot.superclass.must_equal Artoo::Robot
  end
end