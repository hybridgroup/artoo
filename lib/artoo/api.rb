require 'reel'

module ApiRouteHelpers
  module ClassMethods
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
            req.respond(:ok, body)
          rescue Exception => e
            p [:e, e]
            req.respond :not_found, e.inspect
          end
        end
      else
        connection.respond :not_found, "Not found"
        # raise StandardError.new("Route not found")
      end
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

module Artoo
  class Api < Reel::Server
    include ApiRouteHelpers

    def initialize(host = "127.0.0.1", port = 3000)
      super(host, port, &method(:on_connection))
    end

    def on_connection(connection)
      while request = connection.request
        case request
        when Reel::Request
          handle_request(connection, request)
        when Reel::WebSocket
          handle_websocket(connection, request)
        end
      end
    end

    get '/' do
      "Hello, World"
    end

    get '/robots' do
      "Robots: #{Actor[:master].robots.size}"
    end

    get '/robots/:robotid' do
      "yay #{@params['robotid']}"
    end

    get '/robots/:robotid/devices' do
    end

    get '/robots/:robotid/devices/:deviceid' do
      "YES #{@params}"
    end

    def handle_request(connection, request)
      dispatch!(connection, request)
      # case request.url
      #   # GET /
      #   # GET /robots
      #   # GET /robots/:robotid
      #   # GET /robots/:robotid/devices
      #   # GET /robots/:robotid/devices/:deviceid
      #   # PUT /robots/:robotid/devices/:deviceid
      #   # GET /robots/:robotid/connections
      #   # GET /robots/:robotid/connections/:connectionid
      #   # PUT /robots/:robotid/connections/:connectionid
      #   when "/"; return render_index(connection, request)
      #   when "/robots"; return render_robots(connection, request)
      #   when "/robots/:robotid"; return render_robots(connection, request)
      # end

      # Logger.info "404 Not Found: #{request.path}"
      # connection.respond :not_found, "Not found"
    end

    def handle_websocket(connection, sock)
      sock << "Hello everyone out there in WebSocket land!"
      sock.close
    end

    # def render_index(connection, request)
    #   request.respond :ok, "Hello, world!"
    # end

    # def render_robots(connection, request)
    #   request.respond :ok, "Robots: #{Actor[:master].robots.size}"
    # end
  end
end

Artoo::Api.run