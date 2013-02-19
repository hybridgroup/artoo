require 'active_support/inflector'

module Artoo
  module Utility
    def constantize(camel_cased_word)
      ActiveSupport::Inflector.constantize(camel_cased_word)
    end

    def classify(underscored)
      ActiveSupport::Inflector.camelize(underscored)
    end

    def random_string
      (0...8).map{65.+(rand(26)).chr}.join
    end

    def current_instance
      Celluloid::Actor.current
    end

    def current_class
      Celluloid::Actor.current.class
    end
  end
end

# just a bit of syntactic sugar, actually does nothing
# Example:
#  20.seconds => 20
#  1.second => 1
class Integer < Numeric
  def seconds
    return self
  end

  def second
    return self
  end
end
