require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '4567'
device :led, :driver => :led, :pin => 13
device :button, :driver => :button, :pin => 14

work do
  on button, :push => :button_pushed
end

def button_pushed
	led.toggle
end
