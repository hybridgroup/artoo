module Artoo
  module Utility
    # from http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize
    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
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