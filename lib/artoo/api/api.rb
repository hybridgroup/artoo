require 'reel'
require 'artoo/api/route_helpers'
require 'artoo/api/device_event_client'

module Artoo
  module Api
    # Artoo API Server provides an interface to communicate with
    # master class and retrieve information about robots being
    # controlled
    class Server < Reel::Server
      include RouteHelpers

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
          if request.websocket?
            connection.detach
            return 
          end
        end
      end

      # Retrieve api index
      # @return [JSON] MCP index
      get '/api' do
        robots   = master.robots.collect { |r| r.to_hash }
        response = {MCP: {robots: robots, commands: master.commands}}
        MultiJson.dump(response)
      end

      # Retrieve list of master commands
      # @return [JSON] commands
      get '/api/commands' do
        MultiJson.dump({commands: master.commands})
      end

      # Execute master command
      # @return [JSON] result
      any '/api/commands/:commandid' do
        result = master.command(@params['commandid'], *command_params)
        MultiJson.dump({result: result})
      end

      # Retrieve list of robots
      # @return [JSON] robots
      get '/api/robots' do
        robots = master.robots.collect {|r|r.to_hash}
        response = {robots: robots}
        MultiJson.dump(response)
      end

      # Retrieve robot by id
      # @return [JSON] robot
      get '/api/robots/:robotid' do
        validate_robot!
        robot = master.robot(@params['robotid'])
        response = {robot: robot.to_hash}
        MultiJson.dump(response)
      end

      # Retrieve robot commands
      # @return [JSON] commands
      get '/api/robots/:robotid/commands' do
        validate_robot!
        commands = master.robot(@params['robotid']).commands
        MultiJson.dump({commands: commands})
      end

      # Execute robot command
      # @return [JSON] command
      any '/api/robots/:robotid/commands/:commandid' do
        validate_robot!
        result = master.robot(@params['robotid']).command(@params['commandid'], *command_params)
        return MultiJson.dump({'result' => result})
      end

      # Retrieve robot devices
      # @return [JSON] devices
      get '/api/robots/:robotid/devices' do
        validate_robot!
        devices = master.robot_devices(@params['robotid']).each_value.collect {|d| d.to_hash}
        MultiJson.dump({devices: devices})
      end

      # Retrieve robot device
      # @return [JSON] device
      get '/api/robots/:robotid/devices/:deviceid' do
        validate_robot!
        device = device(@params['robotid'], @params['deviceid']).to_hash
        MultiJson.dump({device: device})
      end

      # Retrieve robot commands
      # @return [JSON] commands
      get '/api/robots/:robotid/devices/:deviceid/commands' do
        validate_robot!
        commands = device(@params['robotid'], @params['deviceid']).commands
        MultiJson.dump({commands: commands})
      end

      # Execute robot command
      # @return [JSON] command
      any '/api/robots/:robotid/devices/:deviceid/commands/:commandid' do
        validate_robot!
        result = device(@params['robotid'], @params['deviceid']).command(@params['commandid'], *command_params)
        return MultiJson.dump({'result' => result})
      end

      # Subscribte to robot device events
      # @return [nil]
      get_ws '/robots/:robotid/devices/:deviceid/events/:eventid' do
        DeviceEventClient.new(@req.websocket, device(@params['robotid'], @params['deviceid']).event_topic_name(@params['eventid']))
        return nil
      end

      # Retrieve robot connections
      # @return [JSON] connections
      get '/api/robots/:robotid/connections' do
        validate_robot!
        connections = master.robot_connections(@params['robotid']).each_value.collect {|c| c.to_hash}
        MultiJson.dump({connections: connections})
      end

      # Retrieve robot connection
      # @return [JSON] connection
      get '/api/robots/:robotid/connections/:connectionid' do
        validate_robot!
        connection = master.robot_connection(@params['robotid'], @params['connectionid']).to_hash

        MultiJson.dump({connection: connection})
      end

      protected

      def master
        Actor[:master]
      end

      def device(robot_id, device_id)
        master.robot_device(robot_id, device_id)
      end

      def validate_robot!
        unless master.robot?(@params['robotid'])
          @error = "No Robot found with the name #{@params['robotid']}"
          raise RobotNotFound
        end
      end

      def command_params
        if @req.body.to_s != ""
          data = MultiJson.load(@req.body.to_s, :symbolize_keys => true)
          data.values
        end
      end

    end
  end
end
