require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/rfcomm0' #linux
device :sphero, :driver => :sphero
  
work do
	sphero.set_color(0, 0, 0)
	sphero.set_color(:red)
	sphero.set_color(:yellow)
	sphero.set_color(:green)
	sphero.set_color(0, 255, 255)
	sphero.set_color(:blue)
	sphero.set_color(255, 0, 255)
	sphero.set_color(:white)
end
