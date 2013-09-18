require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

describe Integer do
  it "#second" do
    1.second.must_equal 1
  end

  it "#seconds" do
    20.seconds.must_equal 20
  end
end

describe Numeric do
  it "#to_scale with Integer" do
    2.from_scale(1..10).to_scale(1..20).must_equal 4
  end

  it "#to_scale with angle" do
    90.from_scale(0..180).to_scale(-90..90).must_equal 0
  end

  it "#to_scale with angle" do
    45.from_scale(0..180).to_scale(0..90).must_equal 23
  end

  it "#to_scale with Float" do
    x = 2.5
    x.from_scale(1..10).to_scale(1..20).must_equal 5
  end
end

describe Fixnum do
  it "#to_pwm"
  it "#to_pwm_reverse"
end
