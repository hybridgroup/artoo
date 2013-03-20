require 'artoo'

connection :arduino, :adaptor => :firmata, :port => "8023"
device :classic, :driver => :wiiclassic, :connection => :arduino, :interval => 0.1

work do
  on classic, :a_button => proc { puts "a button pressed!" }
  on classic, :b_button => proc { puts "b button pressed!" }
  on classic, :x_button => proc { puts "x button pressed!" }
  on classic, :y_button => proc { puts "y button pressed!" }
  on classic, :home_button => proc { puts "home button pressed!" }
  on classic, :start_button => proc { puts "start button pressed!" }
  on classic, :select_button => proc { puts "select button pressed!" }
  on classic, :left_joystick => proc { |*value|
    puts "left joystick x: #{value[1][:x]}, y: #{value[1][:y]}" unless (value[1][:x] == 0 && value[1][:y] == 0)
  }
  on classic, :right_joystick => proc { |*value|
    puts "right joystick x: #{value[1][:x]}, y: #{value[1][:y]}" unless (value[1][:x] == 0 && value[1][:y] == 0)
  }
  on classic, :right_trigger => proc { |*value|
    puts "right trigger: #{value[1]}" unless (value[1]== 0)
  }
  on classic, :left_trigger => proc { |*value|
    puts "left trigger: #{value[1]}" unless (value[1]== 0)
  }
end
