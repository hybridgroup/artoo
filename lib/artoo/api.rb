require 'reel'
require 'artoo/api_route_helpers'

module Artoo
  class Api < Reel::Server
    include Artoo::ApiRouteHelpers

    def initialize(host = "127.0.0.1", port = 3000)
      super(host, port, &method(:on_connection))
    end

    def on_connection(connection)
      while request = connection.request
        case request
        when Reel::Request
          dispatch!(connection, request)
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

    def handle_websocket(connection, sock)
      sock << "Hello everyone out there in WebSocket land!"
      sock.close
    end
  end
end
