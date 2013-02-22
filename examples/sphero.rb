require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '4560' #/dev/tty.Sphero-YRR-RN-SPP'
device :sphero, :driver => :sphero
  
work do
  every(3.seconds) do
  	puts "Rolling..."
    sphero.roll 60, rand(360)
  end
end