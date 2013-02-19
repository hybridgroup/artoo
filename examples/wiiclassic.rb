require 'artoo'

connection :arduino, :adaptor => :firmata, :port => "/dev/ttyACM0"
device :classic, :driver => :wiiclassic, :connection => :arduino, :interval => 0.2

work do
  on classic, :a => proc { puts "a pressed" }
  on classic, :b => proc { puts "b pressed" }
  on classic, :x => proc { puts "x pressed" }
  on classic, :y => proc { puts "y pressed" }
end
