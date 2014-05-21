require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/rfcomm0' #linux
device     :sphero, :driver  => :sphero

connection :pebble, :adaptor => :pebble
device     :watch,  :driver  => :pebble, :name => 'pebble'

api :host => '0.0.0.0', :port => '8080'

name 'pebble'

def move_forward
  p 'moving forward'
  sphero.roll 100, 0
  sleep 4
  sphero.stop
end

def move_backward
  p 'moving backward'
  sphero.roll 100, 180
  sleep 4
  sphero.stop
end

def button_push(*data)
  unless data[1].nil?
    case data[1]
    when 'up' then
      move_forward
    when 'select' then
      sphero.set_color(rand(255),rand(255),rand(255))
    when 'down' then
      move_backward
    end
  end
end

work do
  on pebble, :button => :button_push
end
