require 'reel'
require 'artoo/api/route_helpers'
require 'artoo/api/device_event_client'

module Artoo
  module Api
    # Artoo API Server provides an interface to communicate with
    # master class and retrieve information about robots being
    # controlled
    class Server < Reel::Server::HTTP
      include RouteHelpers

      # Create new API server
      # @param [String] host
      # @param [Int]    port
      def initialize(host = "127.0.0.1", port = 3000)
        super(host, port, &method(:on_connection))
      end

      # Dispatches connection requests
      def on_connection(connection)
        while !connection.current_request && request = connection.request
          dispatch!(connection, request)
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
        validate_params!
        MultiJson.dump({robot: @robot.to_hash})
      end

      # Retrieve robot commands
      # @return [JSON] commands
      get '/api/robots/:robotid/commands' do
        validate_params!
        MultiJson.dump({commands: @robot.commands})
      end

      # Execute robot command
      # @return [JSON] command
      any '/api/robots/:robotid/commands/:commandid' do
        validate_params!
        result = @robot.command(@params['commandid'], *command_params)
        return MultiJson.dump({'result' => result})
      end

      # Retrieve robot devices
      # @return [JSON] devices
      get '/api/robots/:robotid/devices' do
        validate_params!
        devices = @robot.devices.each_value.collect {|d| d.to_hash}
        MultiJson.dump({devices: devices})
      end

      # Retrieve robot device
      # @return [JSON] device
      get '/api/robots/:robotid/devices/:deviceid' do
        validate_params!
        MultiJson.dump({device: @device.to_hash})
      end

      # Retrieve robot commands
      # @return [JSON] commands
      get '/api/robots/:robotid/devices/:deviceid/commands' do
        validate_params!
        MultiJson.dump({commands: @device.commands})
      end

      # Execute robot command
      # @return [JSON] command
      any '/api/robots/:robotid/devices/:deviceid/commands/:commandid' do
        validate_params!
        result = @device.command(@params['commandid'], *command_params)
        return MultiJson.dump({'result' => result})
      end

      # Subscribe to robot device events
      # @return [nil]
      get '/api/robots/:robotid/devices/:deviceid/events/:eventid' do
        topic  = @device.event_topic_name(@params['eventid'])

        DeviceEventClient.new(@connection, topic)
        return
      end

      # Retrieve robot connections
      # @return [JSON] connections
      get '/api/robots/:robotid/connections' do
        validate_params!
        connections = @robot.connections.each_value.collect {|c| c.to_hash}
        MultiJson.dump({connections: connections})
      end

      # Retrieve robot connection
      # @return [JSON] connection
      get '/api/robots/:robotid/connections/:connectionid' do
        validate_params!
        MultiJson.dump({connection: @conn.to_hash})
      end

      protected

      def master
        Actor[:master]
      end

      def device(robot_id, device_id)
        master.robot_device(robot_id, device_id)
      end

      def validate_params!
        robot = @params['robotid']
        device = @params['deviceid']
        connection = @params['connectionid']


        if robot
          @robot = master.robot(robot)
          unless @robot
            @error = "No Robot found with the name #{robot}"
            raise RobotNotFound
          end
        end

        if device
          @device = @robot.devices[device.intern]
          unless @device
            @error = "No device found with the name #{device}"
            raise RobotNotFound
          end
        end

        if connection
          @conn = @robot.connections[connection.intern]
          unless @conn
            @error = "No connection found with the name #{connection}"
            raise RobotNotFound
          end
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
