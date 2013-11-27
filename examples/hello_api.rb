require 'artoo/robot'

class HelloRobot < Artoo::Robot
  connection :loop
  device :passthru

  api :host => '127.0.0.1', :port => '4321'

  work do
  	puts "Hello from the API running at #{api_host}:#{api_port}..."
  end

  def hello name
    "hi #{name}!"
  end
end

robots = []
robots << HelloRobot.new(:name => "hello", :commands => [:hello])
HelloRobot.work!(robots)
