require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

#connection :arduino, :adaptor => :firmata, :port => "/dev/ttyACM0"
connection :arduino, :adaptor => :firmata, :port => "4567"
device :classic, :driver => :wiiclassic, :connection => :arduino, :interval => 0.2

work do
  @pitch = 0.1
  on classic, :a_button => proc { 
    puts "Take Off" 
    drone.take_off
  }
  on classic, :b_button => proc { 
    puts "Hover" 
    drone.hover
  }
  on classic, :x_button => proc { 
    puts "Land" 
    drone.land
  }
  on classic, :y_button => proc { 
    puts "Not Mapped!" 
    #drone.start
  }
  on classic, :home_button => proc { 
    puts "EMERGENGY!!!"
    drone.emergency
  }
  on classic, :start_button => proc { 
    puts "Start"
    drone.start
  }
  on classic, :select_button => proc { 
    puts "Stop"
    drone.stop
  }
  on classic, :ly_up => proc {
    puts "Forward"
    drone.forward(@pitch)
  }
  on classic, :ly_down => proc {
    puts "Backward"
    drone.backward(@pitch)
  }
  on classic, :lx_right => proc {
    puts "Right"
    drone.right(@pitch)
  }
  on classic, :lx_left => proc {
    puts "Left"
    drone.left(@pitch)
  }
  on classic, :hover => proc {
    #puts "Stop moving"
    drone.hover
  }
end
