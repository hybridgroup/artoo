require 'artoo'

connection :sphero, :type => :sphero, :port => '/dev/tty.Sphero-BWY-RN-SPP'
device :sphero
  
work do
	sphero.configure_collision_detection 0x01, 0x50, 0x50, 0x50, 0x50, 0x50
	
  every(3.seconds) do
    sphero.roll 60, rand(360)
    if sphero.read_async_messages
    	puts "----------"
    	while m = sphero.async_responses.shift do
    		puts m
    	end
    	puts "=========="
    end
  end
end