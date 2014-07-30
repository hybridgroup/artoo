require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class MockRobot
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def devices
    ["#{name}-device1", "#{name}-device2", "#{name}-device3"]
  end

  def connections
    ["#{name}-connection1", "#{name}-connection2", "#{name}-connection3"]
  end
end

describe Artoo::Master do
  before do
    @robots = []

    @robot1 = MockRobot.new("robot1")
    @robot2 = MockRobot.new("robot2")
    @robot3 = MockRobot.new("robot3")

    @robots << @robot1
    @robots << @robot2
    @robots << @robot3

    @master = Artoo::Master.new(@robots)
  end

  it 'Artoo::Master#robot' do
    @master.robot("robot2").must_equal @robot2
  end

  it 'Artoo::Master#robot with invalid robot name' do
    proc {@master.robot("robotno")}.must_raise(Artoo::RobotNotFound)
  end

  it 'Artoo::Master#robot_devices' do
    @master.robot_devices("robot2").first.must_equal "robot2-device1"
  end

  it 'Artoo::Master#robot_connections' do
    @master.robot_connections("robot2").last.must_equal "robot2-connection3"
  end

  it 'Artoo::Master::#commands' do
    @master.commands.must_equal []
  end

  it 'Artoo::Master::#add_command' do
    @master.add_command :test, lambda{}
    @master.commands.must_equal [:test]
  end

  it 'Artoo::Master::#command' do
    @master.add_command :test, lambda{'test'}
    @master.command(:test, nil).must_equal 'test'
  end

end
