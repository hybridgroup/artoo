require 'artoo/robot'

class TestBot < Artoo::Robot
  connection :loopback, port: '/dev/null', test: 'abc'
  device :ping, driver: 'ping', pin: '13', test: 'abc'

  api host: '127.0.0.1', port: '8080'

  work do
    every(5) { ping }
  end

  def hello name
    "Hello, #{name}!"
  end

end

test_bot = TestBot.new(:name => "TestBot", commands: [:hello])

Artoo::Master.add_command(:echo, lambda { |param| param })

TestBot.work!([test_bot])
