require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

#connection :arduino, :adaptor => :firmata, :port => "/dev/ttyACM0"
connection :arduino, :adaptor => :firmata, :port => "4567"
device :classic, :driver => :wiiclassic, :connection => :arduino, :interval => 0.2

work do
  @rotate_pitch = 0.5
  @fly_pitch = 0.2
  @altitude_pitch = 0.5
  @toggle_camera = 0
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
    puts "Toggle camera" 
    if @toggle_camera == 0
      puts "Bottom Camera Enabled"
      drone.bottom_camera
      @toggle_camera = 1
    else
      puts "Front Camera Enabled"
      drone.front_camera
      @toggle_camera = 0
    end
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
  on classic, :ry_up => proc {
    puts "Down"
    drone.down(@altitude_pitch)
  }
  on classic, :ry_down => proc {
    puts "Up"
    drone.up(@altitude_pitch)
  }
  on classic, :ly_up => proc {
    puts "Backward"
    drone.backward(@fly_pitch)
  }
  on classic, :ly_down => proc {
    puts "Forward"
    drone.forward(@fly_pitch)
  }
  on classic, :lx_right => proc {
    puts "Right"
    drone.right(@fly_pitch)
  }
  on classic, :lx_left => proc {
    puts "Left"
    drone.left(@fly_pitch)
  }
  on classic, :reset_pitch_roll => proc {
    drone.left(0.0)
    drone.forward(0.0)
  }
  on classic, :rotate_left => proc {
    puts "rotate left"
    drone.turn_left(@rotate_pitch)
  } 
  on classic, :rotate_right => proc {
    puts "rotate right"
    drone.turn_right(@rotate_pitch)
  }
  on classic, :reset_rotate => proc{
    drone.turn_left(0.0)
  }
  
end
