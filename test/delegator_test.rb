require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class DelegatorTest < Minitest::Test
  class Mirror
    attr_reader :last_call
    def method_missing(*a, &b)
      @last_call = [*a.map(&:to_s)]
      @last_call << b if b
    end
  end

  def self.delegates(name)
    define_method "test_delegates_#{name}" do
      m = mirror { send name }
      assert_equal [name.to_s], m.last_call
    end

    define_method "test_delegates_#{name}_with_arguments" do
      m = mirror { send name, "foo", "bar" }
      assert_equal [name.to_s, "foo", "bar"], m.last_call
    end

    define_method "test_delegates_#{name}_with_block" do
      block = proc { }
      m = mirror { send(name, &block) }
      assert_equal [name.to_s, block], m.last_call
    end
  end

  def setup
    @target_was = Artoo::Delegator.target
  end

  def teardown
    Artoo::Delegator.target = @target_was
  end

  def delegation_robot(&block)
    mock_robot { Artoo::Delegator.target = self }
    delegate(&block)
  end

  def mirror(&block)
    mirror = Mirror.new
    Artoo::Delegator.target = mirror
    delegate(&block)
  end

  def delegate(&block)
    assert Artoo::Delegator.target != Artoo::MainRobot
    Object.new.extend(Artoo::Delegator).instance_eval(&block) if block
    Artoo::Delegator.target
  end

  def target
    Artoo::Delegator.target
  end

  def test_defaults_to_mainrobot_as_target
    assert_equal Artoo::MainRobot, Artoo::Delegator.target
  end

  def test_delegates_crazy_method_names
    Artoo::Delegator.delegate "foo:bar:"
    method = mirror { send "foo:bar:" }.last_call.first
    assert_equal "foo:bar:", method
  end

  delegates 'work'
  delegates 'device'
end
