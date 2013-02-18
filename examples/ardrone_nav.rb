require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

connection :navigation, :adaptor => :ardrone_navigation, :port => '192.168.1.1:5554'
device :nav, :driver => :ardrone_navigation, :connection => :navigation

work do
	on nav, :update => :nav_update
	drone.start
	drone.take_off
	sleep 10
	drone.hover.land
	sleep 10
	drone.stop
end

def nav_update(data)
	data.drone_state.each do |name, val|
  	p "#{name}: #{val}"
	end
end