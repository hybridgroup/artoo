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
      "Hello, World. The single page app goes here..."
    end

    get '/robots' do
      result = "{"
      Actor[:master].robots.each { |r|
        result << r.as_json
      }
      result << "}"
      result
    end

    get '/robots/:robotid' do
      Actor[:master].get_robot_by_name(@params['robotid']).as_json
    end

    get '/robots/:robotid/devices' do
      result = "{"
      Actor[:master].get_robot_by_name(@params['robotid']).devices.each_value { |d|
        result << d.as_json
      }
      result << "}"
      result
    end

    get '/robots/:robotid/devices/:deviceid' do
      Actor[:master].get_robot_by_name(@params['robotid']).devices[@params['deviceid'].intern].as_json
    end

    get '/robots/:robotid/connections' do
      result = "{"
      Actor[:master].get_robot_by_name(@params['robotid']).connections.each_value { |c|
        result << c.as_json
      }
      result << "}"
      result
    end

    get '/robots/:robotid/connections/:connectionid' do
      Actor[:master].get_robot_by_name(@params['robotid']).connections[@params['connectionid'].intern].as_json
    end

    def handle_websocket(connection, sock)
      sock << "Hello everyone out there in WebSocket land!"
      sock.close
    end
  end
end
