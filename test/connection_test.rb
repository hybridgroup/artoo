require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class ConnectionTestRobot < Artoo::Robot
	connection :test_connection
end

describe Artoo::Connection do
	before do
		@robot = ConnectionTestRobot.new
		@connection = @robot.default_connection
	end

  it 'Artoo::Connection#connect' do
  	@connection.connect
  	@connection.connector.must_be_kind_of Artoo::Connector::Loopback
  end

  it 'Artoo::Connection#disconnect'
end