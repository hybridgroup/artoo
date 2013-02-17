require 'artoo'

connection :arduino, :adaptor => :firmata, :port => '4567'
device :led, :driver => :led, :pin => 13
device :button, :driver => :button, :pin => 2

work do
  on button, :push => :button_pushed
end

def button_pushed(*payload)
  led.toggle
end
