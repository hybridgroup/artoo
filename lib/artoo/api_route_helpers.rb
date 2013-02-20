# route helpers used within the Artoo::Api class
module Artoo
  module ApiRouteHelpers
    class ResponseHandled < StandardError; end
    module ClassMethods

      def static_path(default=File.join(File.dirname(__FILE__), "..", "..", "public"))
        @static_path ||= default
      end

      def routes
        @routes ||= {}
      end

      def route(verb, path, &block)
        signature = compile!(verb, path, block, {})
        (routes[verb] ||= []) << signature
      end

      ## Ripped from Sinatra 'cause it's so sexy in there
      def generate_method(method_name, &block)
        define_method(method_name, &block)
        method = instance_method method_name
        remove_method method_name
        method
      end

      def compile!(verb, path, block, options = {})
        options.each_pair { |option, args| send(option, *args) }
        method_name             = "#{verb} #{path}"
        unbound_method          = generate_method(method_name, &block)
        pattern, keys           = compile path
        conditions, @conditions = @conditions, []

        [ pattern, keys, conditions, block.arity != 0 ?
            proc { |a,p| unbound_method.bind(a).call(*p) } :
            proc { |a,p| unbound_method.bind(a).call } ]
      end

      def compile(path)
        keys = []
        if path.respond_to? :to_str
          ignore = ""
          pattern = path.to_str.gsub(/[^\?\%\\\/\:\*\w]/) do |c|
            ignore << escaped(c).join if c.match(/[\.@]/)
            patt = encoded(c)
            patt.gsub(/%[\da-fA-F]{2}/) do |match|
              match.split(//).map {|char| char =~ /[A-Z]/ ? "[#{char}#{char.tr('A-Z', 'a-z')}]" : char}.join
            end
          end
          pattern.gsub!(/((:\w+)|\*)/) do |match|
            if match == "*"
              keys << 'splat'
              "(.*?)"
            else
              keys << $2[1..-1]
              ignore_pattern = safe_ignore(ignore)

              ignore_pattern
            end
          end
          [/\A#{pattern}\z/, keys]
        elsif path.respond_to?(:keys) && path.respond_to?(:match)
          [path, path.keys]
        elsif path.respond_to?(:names) && path.respond_to?(:match)
          [path, path.names]
        elsif path.respond_to? :match
          [path, keys]
        else
          raise TypeError, path
        end
      end

      def safe_ignore(ignore)
        unsafe_ignore = []
        ignore = ignore.gsub(/%[\da-fA-F]{2}/) do |hex|
          unsafe_ignore << hex[1..2]
          ''
        end
        unsafe_patterns = unsafe_ignore.map do |unsafe|
          chars = unsafe.split(//).map do |char|
            if char =~ /[A-Z]/
              char <<= char.tr('A-Z', 'a-z')
            end
            char
          end

          "|(?:%[^#{chars[0]}].|%[#{chars[0]}][^#{chars[1]}])"
        end
        if unsafe_patterns.length > 0
          "((?:[^#{ignore}/?#%]#{unsafe_patterns.join()})+)"
        else
          "([^#{ignore}/?#]+)"
        end
      end

      # Helper route functions
      def get(path, &block)
        route 'GET', path, &block
      end
      def put(path, &block)
        route 'PUT', path, &block
      end
    end
    
    module InstanceMethods
      ## Handle the request
      def dispatch!(connection, req)
        resp = catch(:halt) do
          try_static! connection, req
          route!      connection, req
        end
        if resp && !resp.nil?
          status, body = resp
          req.respond status, body
        else
          req.respond :not_found, "NOT FOUND"
        end
      end

      # Exit the current block, halts any further processing
      # of the request, and returns the specified response.
      def halt(*response)
        response = response.first if response.length == 1
        throw :halt, response
      end

      def try_static!(connection, req)
        fpath = req.url == '/' ? 'index.html' : req.url[1..-1]
        filepath = File.expand_path(fpath, self.class.static_path)
        if File.file?(filepath)
          # TODO: stream this?
          data = open(filepath).read
          halt :ok, data
        end
      end

      def route!(connection, req)
        if routes = self.class.routes[req.method]
          routes.each do |pattern, keys, conditions, block|
            route = req.url
            next unless match = pattern.match(route)
            values = match.captures.to_a.map { |v| URI.decode_www_form_component(v) if v }
            if values.any?
              params = {}
              keys.zip(values) { |k,v| Array === params[k] ? params[k] << v : params[k] = v if v }
              @params = params
            end

            begin
              body = block ? block[self, values] : yield(self, values)
              halt [:ok, body]
            rescue Exception => e
              p [:e, e]
            end
          end
        end
        nil
      end

      # Fixes encoding issues by
      # * defaulting to UTF-8
      # * casting params to Encoding.default_external
      #
      # The latter might not be necessary if Rack handles it one day.
      # Keep an eye on Rack's LH #100.
      def force_encoding(*args) settings.force_encoding(*args) end
      if defined? Encoding
        def self.force_encoding(data, encoding = default_encoding)
          return if data == settings || data.is_a?(Tempfile)
          if data.respond_to? :force_encoding
            data.force_encoding(encoding).encode!
          elsif data.respond_to? :each_value
            data.each_value { |v| force_encoding(v, encoding) }
          elsif data.respond_to? :each
            data.each { |v| force_encoding(v, encoding) }
          end
          data
        end
      else
        def self.force_encoding(data, *) data end
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end