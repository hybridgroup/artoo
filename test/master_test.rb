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
    @master.robot("robotno").must_equal(nil)
  end

  describe "#commands" do
    it "returns all Master commands" do
      command = lambda { |e| e }
      @master.commands.must_equal({})
      @master.instance_variable_set(:@commands, { 'hello' => command })
      @master.commands.must_equal({ 'hello' => command })
    end
  end

  describe "#add_command" do
    it "adds a command to the Master" do
      echo = lambda { |e| e }
      @master.add_command(:echo, echo)
      @master.commands.must_equal({ 'echo' => echo })
    end
  end
end
