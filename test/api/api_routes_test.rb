require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

describe "API routes" do

  let(:base) { 'http://localhost:8080' }

  def validate_route(relative_path, status=200)
    res = HTTP.get(base + relative_path)
    res.status.must_equal status
  end

  def validate_form(relative_path, params)
    res = HTTP.post base + '/api/commands/echo', :body => JSON.dump(params)

    res.status.must_equal 200
  end

  before :all do
    @pid = fork { require_relative '../../examples/test_bot' }
    sleep 1
  end

  after (:all) { system("kill -9 #{@pid}") }

  it 'must respond to expected routes' do
    validate_route('/api')
    validate_route('/api/commands')
    validate_route('/api/robots')
    validate_route('/api/robots/TestBot')
    validate_route('/api/robots/NonExistentBot', 404)
    validate_route('/api/robots/TestBot/commands')
    validate_route('/api/robots/TestBot/commands/hello')
    validate_route('/api/robots/TestBot/devices')
    validate_route('/api/robots/TestBot/devices/ping')
    validate_route('/api/robots/TestBot/devices/ping/commands')
    validate_route('/api/robots/TestBot/connections')
    validate_route('/api/robots/TestBot/connections/loopback')
  end

  it 'must respond to command calls' do
    validate_form('/api/commands/echo', { param: 'pong' })
    validate_form('/api/robots/TestBot/devices/ping/commands/ping',
                  { name: 'bot' })
  end

end
