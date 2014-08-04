require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class ConnectionTestRobot < Artoo::Robot
  connection :my_test_connection, :awesomeness => :high, :super_powers => :active
end

describe Artoo::Connection do
  before do
    @robot = ConnectionTestRobot.new
    @connection = @robot.default_connection
  end

  it 'Artoo::Connection#connect' do
    @connection.connect
    @connection.adaptor.class.must_equal Artoo::Adaptors::Loopback
  end

  it 'Artoo::Connection#disconnect' do
    @connection.connect
    @connection.disconnect
    @connection.connected?.must_equal false
  end

  it 'Artoo::Connection#as_json' do
    MultiJson.load(@connection.as_json, :symbolize_keys => true)[:name].must_equal "my_test_connection"
    MultiJson.load(@connection.as_json, :symbolize_keys => true)[:adaptor].must_equal "Loopback"
  end

  it 'Artoo::Connection#additional_params' do
    @robot.default_connection.adaptor.additional_params[:awesomeness].must_equal :high
  end
end
