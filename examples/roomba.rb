require 'artoo'

connection :roomba, :adaptor => :roomba, :port => '/dev/ttyUSB0'
device :roomba, :driver => :roomba, :connection => :roomba
  
work do
  roomba.safe_mode
  roomba.nudge_left
  roomba.nudge_right
  roomba.nudge_right
  roomba.nudge_left
end
