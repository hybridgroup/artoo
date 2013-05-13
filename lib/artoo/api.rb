require 'reel'
require 'artoo/api_route_helpers'
require 'artoo/device_event_client'

module Artoo
  # Artoo API Server provides an interface to communicate with
  # master class and retrieve information about robots being
  # controlled
  class Api < Reel::Server
    include Artoo::ApiRouteHelpers

    # Create new API server
    # @param [String] host
    # @param [Int]    port
    def initialize(host = "127.0.0.1", port = 3000)
      super(host, port, &method(:on_connection))
    end

    # Dispatches connection requests
    def on_connection(connection)
      while request = connection.request
        dispatch!(connection, request)
      end
    end

    # Retrieve list of robots
    # @return [JSON] robots
    get '/robots' do
      MultiJson.dump(master.robots.collect {|r|r.to_hash})
    end

    # Retrieve robot by id
    # @return [JSON] robot
    get '/robots/:robotid' do
      master.robot(@params['robotid']).as_json
    end

    # Retrieve robot devices
    # @return [JSON] devices
    get '/robots/:robotid/devices' do
      MultiJson.dump(master.robot_devices(@params['robotid']).each_value.collect {|d| d.to_hash})
    end

    # Retrieve robot device
    # @return [JSON] device
    get '/robots/:robotid/devices/:deviceid' do
      device(@params['robotid'], @params['deviceid']).as_json
    end

    # Retrieve robot commands
    # @return [JSON] commands
    get '/robots/:robotid/devices/:deviceid/commands' do
      MultiJson.dump(device(@params['robotid'], @params['deviceid']).commands)
    end

    # Execute robot command
    # @return [JSON] command
    post '/robots/:robotid/devices/:deviceid/commands/:commandid' do
      result = device(@params['robotid'], @params['deviceid']).command(@params['commandid'], command_params)
      return MultiJson.dump({'result' => result})
    end

    # Subscribte to robot device events
    # @return [nil]
    get_ws '/robots/:robotid/devices/:deviceid/events' do
      DeviceEventClient.new(@req, device(@params['robotid'], @params['deviceid']).event_topic_name('update'))
      return nil
    end

    # Retrieve robot connections
    # @return [JSON] connections
    get '/robots/:robotid/connections' do
      MultiJson.dump(master.robot_connections(@params['robotid']).each_value.collect {|c| c.to_hash})
    end

    # Retrieve robot connection
    # @return [JSON] connection
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

    def command_params
      data = MultiJson.load(@req.body, :symbolize_keys => true)
      if data
        data[:params]
      else
        nil
      end
    end
  end
end
