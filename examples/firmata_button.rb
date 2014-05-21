require 'artoo'

connection :arduino, :adaptor => :firmata, :port => '/dev/ttyACM0' #linux
device :led, :driver => :led, :pin => 13
device :button, :driver => :button, :pin => 2

work do
  on button, :push => proc {led.toggle}
end
