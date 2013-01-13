require File.expand_path(File.dirname(__FILE__) + "/test_helper")
require 'artoo/delegator'

describe Artoo do
  it 'must create a new Artoo::Robot subclass on new' do
    robot = Artoo.new {
    	connection :test_connection
    	work { puts 'Hello World' } 
    }
    robot.superclass.must_equal Artoo::Robot
  end
end