require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/rfcomm0' #linux
device :sphero, :driver => :sphero

work do
  every(1.seconds) do
    puts "Rolling..."
    sphero.set_color(rand(255),rand(255),rand(255))
    sphero.roll 20, rand(360)
  end
end

