require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class Awesomeness < Artoo::Interfaces::Interface
  COMMANDS = [:awesome].freeze

  def interface_type
    :awesomeness
  end

  def awesome
    true
  end
end

describe Artoo::Interfaces::Interface do
  before do
    @robot = mock('robot')
    @device = mock('device')
    @interface = Awesomeness.new(:robot => @robot, :device => @device)
  end

  it 'Interface#interface_type' do
    @interface.interface_type.must_equal :awesomeness
  end

  it 'Interface#commands' do
    @interface.commands.first.must_equal :awesome
  end  
end
