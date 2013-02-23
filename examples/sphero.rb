require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '4560'
device :sphero, :driver => :sphero
  
work do
  every(3.seconds) do
  	puts "Rolling..."
    sphero.roll 60, rand(360)
  end
end