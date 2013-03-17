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
5.times do |i|
	robots << HelloRobot.new(:name => "Number #{i}")
end

HelloRobot.work!(robots)
