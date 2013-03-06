begin
  require 'artoo'
rescue LoadError
  $LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'..', 'lib')))
  require "artoo"
end

connection :roomba, :adaptor => :roomba, :port => '/dev/tty.usbserial-A2001yzl'
device :roomba, :driver => :roomba, :connection => :roomba
  
work do
  roomba.safe_mode
  roomba.nudge_left
  roomba.nudge_right
  roomba.nudge_right
  roomba.nudge_left
  roomba.sing_jingle_bells
end