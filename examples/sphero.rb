require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
device :sphero, :driver => :sphero
  
work do
  every(3.seconds) do
  	puts "Rolling..."
    sphero.roll 90, rand(360)
  end
end