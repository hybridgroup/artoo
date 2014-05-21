require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/rfcomm0' #linux
device :sphero, :driver => :sphero

work do
  every(1.seconds) do
  	puts "Rolling..."
    sphero.roll 90, rand(360)
  end
end
