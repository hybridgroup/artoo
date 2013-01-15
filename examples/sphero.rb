require 'artoo'

connection :sphero, :type => :sphero, :port => '/dev/tty.Sphero-YBW-RN-SPP'

#device :collision_detect, :driver => :switch, :pin => 3
#device :motor, :driver => :l293_motor, :pin => 4
  
work do
  every(3.seconds) do
     puts "hello"
  end
  after(10.seconds) do
  	puts "wow"
  end
end