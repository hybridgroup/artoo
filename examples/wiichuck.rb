require 'artoo'

connection :arduino, :adaptor => :firmata, :port => "8023"
device :wiichuck, :driver => :wiichuck, :connection => :arduino, :interval => 0.1

work do
  on wiichuck, :c_button => proc { puts "c button pressed!" }
  on wiichuck, :z_button => proc { puts "z button pressed!" }
  on wiichuck, :joystick => proc { |*value|
    puts "joystick x: #{value[1][:x]}, y: #{value[1][:y]}"
  }
end
