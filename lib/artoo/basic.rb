module Artoo
  # Methods taken from Sinatra codebase
  module Basic
    # Sets an option to the given value.  If the value is a proc,
    # the proc will be called every time the option is accessed.
    def set(option, value = (not_set = true), ignore_setter = false, &block)
      raise ArgumentError if block and !not_set
      value, not_set = block, false if block

      if not_set
        raise ArgumentError unless option.respond_to?(:each)
        option.each { |k,v| set(k, v) }
        return self
      end

      if respond_to?("#{option}=") and not ignore_setter
        return __send__("#{option}=", value)
      end

      setter = proc { |val| set option, val, true }
      getter = proc { value }

      case value
      when Proc
        getter = value
      when Symbol, Fixnum, FalseClass, TrueClass, NilClass
        getter = value.inspect
      when Hash
        setter = proc do |val|
          val = value.merge val if Hash === val
          set option, val, true
        end
      end

      define_singleton_method("#{option}=", setter) if setter
      define_singleton_method(option, getter) if getter
      define_singleton_method("#{option}?", "!!#{option}") unless method_defined? "#{option}?"
      self
    end

    # Callers to ignore
    CALLERS_TO_IGNORE = [ # :nodoc:
      /lib\/artoo.*\.rb$/,                                # artoo code
      /^\(.*\)$/,                                         # generated code
      /rubygems\/(custom|core_ext\/kernel)_require\.rb$/, # rubygems require hacks
      /active_support/,                                   # active_support require hacks
      /bundler(\/runtime)?\.rb/,                          # bundler require hacks
      /<internal:/,                                       # internal in ruby >= 1.9.2
      /src\/kernel\/bootstrap\/[A-Z]/                     # maglev kernel files
    ]

    # Like Kernel#caller but excluding certain magic entries and without
    # line / method information; the resulting array contains filenames only.
    def caller_files
      cleaned_caller(1).flatten
    end

    private

    # Replace with call to singleton_class once we're 1.9 only
    def define_singleton_method(name, content = Proc.new)
      (class << self; self; end).class_eval do
        undef_method(name) if method_defined? name
        String === content ? class_eval("def #{name}() #{content}; end") : define_method(name, &content)
      end
    end

    # Like Kernel#caller but excluding certain magic entries
    def cleaned_caller(keep = 3)
      caller(1).
        map    { |line| line.split(/:(?=\d|in )/, 3)[0,keep] }.
        reject { |file, *_| CALLERS_TO_IGNORE.any? { |pattern| file =~ pattern } }
    end
  end
end
