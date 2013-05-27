require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4569'
device :sphero, :driver => :sphero
  
work do
  every(1.seconds) do
  	puts "Rolling..."
    sphero.roll 90, rand(360)
  end
end
