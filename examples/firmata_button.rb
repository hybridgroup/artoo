require 'artoo'

connection :arduino, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :led, :driver => :led, :pin => 13
device :button, :driver => :button, :pin => 2

work do
  on button, :push => proc {led.toggle}
end
