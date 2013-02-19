require 'artoo'

connection :arduino, :adaptor => :firmata, :port => "/dev/ttyACM0"
device :classic, :driver => :wiiclassic, :connection => :arduino

work do
  on classic, :a => proc { puts "a pressed" }
  on classic, :b => proc { puts "a pressed" }
  on classic, :x => proc { puts "a pressed" }
  on classic, :y => proc { puts "a pressed" }
end
