require 'reel'
require 'artoo/api_route_helpers'
require 'artoo/device_event_client'

module Artoo
  class Api < Reel::Server
    include Artoo::ApiRouteHelpers

    def initialize(host = "127.0.0.1", port = 3000)
      super(host, port, &method(:on_connection))
    end

    def on_connection(connection)
      while request = connection.request
        dispatch!(connection, request)
      end
    end

    get '/robots' do
      MultiJson.dump(Actor[:master].robots.collect {|r|r.to_hash})
    end

    get '/robots/:robotid' do
      get_robot(@params['robotid']).as_json
    end

    get '/robots/:robotid/devices' do
      MultiJson.dump(get_robot_devices(@params['robotid']).each_value.collect {|d| d.to_hash})
    end

    get '/robots/:robotid/devices/:deviceid' do
      get_robot_devices(@params['robotid'])[@params['deviceid'].intern].as_json
    end

    get_ws '/robots/:robotid/devices/:deviceid/events' do
      DeviceEventClient.new(@req, get_robot_device(@params['robotid'], @params['deviceid']).event_topic_name('update'))
      return nil
    end

    get '/robots/:robotid/connections' do
      MultiJson.dump(get_robot_connections(@params['robotid']).each_value.collect {|c| c.to_hash})
    end

    get '/robots/:robotid/connections/:connectionid' do
      get_robot_connection(@params['robotid'], @params['connectionid']).as_json
    end

    def get_robot(robot_id)
      Actor[:master].get_robot_by_name(robot_id)
    end

    def get_robot_devices(robot_id)
      get_robot(robot_id).devices
    end

    def get_robot_device(robot_id, device_id)
      get_robot_devices(robot_id)[device_id.intern]
    end

    def get_robot_connections(robot_id)
      get_robot(robot_id).connections
    end

    def get_robot_connection(robot_id, connection_id)
      get_robot_connections(robot_id)[connection_id.intern]
    end
  end
end
