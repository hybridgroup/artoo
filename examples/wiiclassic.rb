require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

connection :arduino, :adaptor => :firmata, :port => "/dev/ttyACM0"
device :classic, :driver => :wiiclassic, :connection => :arduino, :interval => 0.2

work do
  @pitch = 0.5
  drone.start
  on classic, :a_button => proc { 
    puts "take off!" 
    drone.take_off
  }
  on classic, :b_button => proc { 
    puts "hover!" 
    drone.hover
  }
  on classic, :x_button => proc { 
    puts "land!" 
    drone.land
  }
  on classic, :y_button => proc { 
    puts "Not Mapped!" 
    #drone.stop
  }
  on classic, :home_button => proc { 
    puts "EMERGENGY!!!"
    drone.emergency
  }
  on classic, :ly_up => proc {
    puts "Forward!"
    drone.forward(@pitch)
    sleep 1
  }
  on classic, :ly_down => proc {
    puts "Backward!"
    drone.backward(@pitch)
    sleep 1
  }
  on classic, :lx_right => proc {
    puts "Right!"
    drone.right(@pitch)
    sleep 1
  }
  on classic, :lx_left => proc {
    puts "Left!"
    drone.left(@pitch)
    sleep 1
  }
end
