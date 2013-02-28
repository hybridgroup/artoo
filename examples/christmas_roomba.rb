require 'artoo'

connection :roomba, :adaptor => :roomba, :port => '/dev/ttyUSB0'
device :roomba, :driver => :roomba, :connection => :roomba
  
work do
  roomba.turn_around
  roomba.turn_around
  roomba.sing_jingle_bells
end