# Adds syntactic suger for seconds
class Integer < Numeric
  # @return [Integer] Plain number, actually does nothing
  # @example 20.seconds => 20
  def seconds
    return self
  end

  # @return [Integer] Plain number, actually does nothing
  # @example 1.second => 1
  def second
    return self
  end
end

# helpful conversions
class Fixnum
  # convert to PWM value from analog reading
  def to_pwm
    ((255.0 / 1023.0) * self.to_f).round
  end

  # convert to PWM value from analog reading
  def to_pwm_reverse
    ((255.0 / 1023.0) * (1023 - self.to_f)).round
  end
end

class Numeric
  # convert value from old scale (min to max) to (0..1) scale
  def from_scale(range)
    (self.to_f - range.min) / (range.max - range.min)
  end

  # convert value from (0..1) scale to new (min to max) scale
  def to_scale(range)
    ((self.to_f * (range.max - range.min) + range.min).ceil).within(range)
  end

  # keep returned value absolutely within range
  def within(range)
    case
    when self < range.min
      range.min
    when self > range.max
      range.max
    else
      self
    end
  end
end
