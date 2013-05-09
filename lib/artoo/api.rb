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
      MultiJson.dump(master.robots.collect {|r|r.to_hash})
    end

    get '/robots/:robotid' do
      master.robot(@params['robotid']).as_json
    end

    get '/robots/:robotid/devices' do
      MultiJson.dump(master.robot_devices(@params['robotid']).each_value.collect {|d| d.to_hash})
    end

    get '/robots/:robotid/devices/:deviceid' do
      device(@params['robotid'], @params['deviceid']).as_json
    end

    get '/robots/:robotid/devices/:deviceid/commands' do
      MultiJson.dump(device(@params['robotid'], @params['deviceid']).commands)
    end

    get_ws '/robots/:robotid/devices/:deviceid/events' do
      DeviceEventClient.new(@req, device(@params['robotid'], @params['deviceid']).event_topic_name('update'))
      return nil
    end

    get '/robots/:robotid/connections' do
      MultiJson.dump(master.robot_connections(@params['robotid']).each_value.collect {|c| c.to_hash})
    end

    get '/robots/:robotid/connections/:connectionid' do
      master.robot_connection(@params['robotid'], @params['connectionid']).as_json
    end

    protected

    def master
      Actor[:master]
    end

    def device(robot_id, device_id)
      master.robot_device(robot_id, device_id)
    end
  end
end
