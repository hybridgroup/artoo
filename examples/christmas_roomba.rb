require 'artoo'

connection :roomba, :adaptor => :roomba, :port => '/dev/tty.usbserial-A2001yzl'
device :roomba, :driver => :roomba, :connection => :roomba
  
work do
  roomba.safe_mode
  roomba.nudge_left
  roomba.nudge_right
  roomba.sing_jingle_bells
end