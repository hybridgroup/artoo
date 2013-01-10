require File.expand_path(File.dirname(__FILE__) + "/test_helper")

describe Artoo do
	it 'must create a new Artoo::Robot subclass on new' do
    robot = Artoo.new { work() { 'Hello World' } }
    assert_same Artoo::Robot, robot.superclass
  end
end