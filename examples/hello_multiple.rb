require 'artoo/robot'

class HelloRobot < Artoo::Robot
	connection :loop
  
	work do
	  every(3.seconds) do
	     puts "Hello from #{name}"
	  end
	  after(10.seconds) do
	  	puts "#{name} is alive!" if name == 'Number 5'
	  end
	end
end

robots = []
robots << HelloRobot.new(:name => "Number 1")
robots << HelloRobot.new(:name => "Number 2")
robots << HelloRobot.new(:name => "Number 3")
robots << HelloRobot.new(:name => "Number 4")
robots << HelloRobot.new(:name => "Number 5")

robots.each {|r| r.work}
sleep
