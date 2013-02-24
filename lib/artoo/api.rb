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
      Actor[:master].get_robot_by_name(@params['robotid']).as_json
    end

    get '/robots/:robotid/devices' do
      MultiJson.dump(Actor[:master].get_robot_by_name(@params['robotid']).devices.each_value.collect {|d| d.to_hash})
    end

    get '/robots/:robotid/devices/:deviceid' do
      Actor[:master].get_robot_by_name(@params['robotid']).devices[@params['deviceid'].intern].as_json
    end

    get_ws '/robots/:robotid/devices/:deviceid/events' do
      DeviceEventClient.new(@req, Actor[:master].get_robot_by_name(@params['robotid']).devices[@params['deviceid'].intern].event_topic_name('update'))
      return nil
    end

    get '/robots/:robotid/connections' do
      MultiJson.dump(Actor[:master].get_robot_by_name(@params['robotid']).connections.each_value.collect {|c| c.to_hash})
    end

    get '/robots/:robotid/connections/:connectionid' do
      Actor[:master].get_robot_by_name(@params['robotid']).connections[@params['connectionid'].intern].as_json
    end
  end
end
