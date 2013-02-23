require 'artoo/robot'

class HelloRobot < Artoo::Robot
	connection :loopback1
	connection :loopback2
	connection :loopback3
	device :passthru1
	device :passthru2
	device :pinger, :driver => :pinger
	device :pinger2, :driver => :pinger2

	api :host => '127.0.0.1', :port => '4321'

	work do
		puts "Hello from '#{name}' attached to API running at #{api_host}:#{api_port}..."
	end
end

robots = []
5.times do |i|
	robots << HelloRobot.new(:name => "Number #{i}")
end

HelloRobot.work!(robots)
sleep
