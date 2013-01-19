require 'artoo'
gem 'argus'
require 'argus'

connection :ardrone, :type => :ardrone
device :drone
  
work do
	drone.start
	drone.take_off
	sleep 5
	drone.hover.land
	sleep 5
	drone.stop
end