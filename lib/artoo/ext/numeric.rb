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

  # convert value from old scale (min to max) to new scale (0 to new_max)
  def to_scale(min, max, new_scale)
    (((self.to_f - min) / (max - min)) * new_max).round
  end
end
