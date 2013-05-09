module Artoo
  # Utility methods used for convertions
  module Utility

    # Converts camel_cased_word to constant
    # @example "CamelCasedWord" > CamelCasedWord
    # @return [Constant] Converted constant
    def constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check it it's owned
          # directly before we reach Object or the end of ancestors.
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

    # Convert a underscore string to a class
    # @example "underscore_word" > UnderscoreWord
    # @return [Class] converted class
    def classify(word)
      underscore(word).gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end

    # @return [String] random string
    def random_string
      (0...8).map{65.+(rand(26)).chr}.join
    end

    # Converts camel cased word to downcased with undercores
    # @example CamelCase > camel_case
    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    # @return [Celluloid::Actor] current instance
    def current_instance
      Celluloid::Actor.current
    end

    # @return [Class] current class
    def current_class
      Celluloid::Actor.current.class
    end
  end
end

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
