require 'artoo/robot'

class SpheroRobot < Artoo::Robot
	connection :sphero, :type => :sphero
	device :sphero
  
	work do
  	every(3.seconds) do
    	sphero.roll 60, rand(360)
  	end
	end
end

robots = []
robots << SpheroRobot.new(:name => "Number 1", 
													:connections => 
														{:sphero => 
															{:port => "/dev/tty.Sphero-YBW-RN-SPP"}})
robots << SpheroRobot.new(:name => "Number 2", 
													:connections => 
														{:sphero => 
															{:port => "/dev/tty.Sphero-BWY-RN-SPP"}})

robots.each {|r| r.work}
sleep
