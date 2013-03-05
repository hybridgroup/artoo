require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

connection :arduino, :adaptor => :firmata, :port => "8023"
device :classic, :driver => :wiiclassic, :connection => :arduino, :interval => 0.1

work do
  init_settings

  on classic, :a_button => proc { drone.take_off }
  on classic, :b_button => proc { drone.hover }
  on classic, :x_button => proc { drone.land }
  on classic, :y_button => proc { 
    if @toggle_camera == 0
      drone.bottom_camera
      @toggle_camera = 1
    else
      drone.front_camera
      @toggle_camera = 0
    end
  }
  on classic, :home_button => proc { drone.emergency }
  on classic, :start_button => proc { drone.start }
  on classic, :select_button => proc { drone.stop }
  on classic, :ry_up => proc { |*value|
    drone.up(value[1]) 
  }
  on classic, :ry_down => proc { |*value|
    drone.down(value[1]) 
  }
  on classic, :ly_up => proc { |*value|
    drone.forward(value[1]) 
  }
  on classic, :ly_down =>proc { |*value| 
    drone.backward(value[1]) 
  }
  on classic, :lx_right => proc { |*value|
    drone.right(value[1]) 
  }
  on classic, :lx_left => proc { |*value|
    drone.left(value[1]) 
  }
  on classic, :rotate_left => proc { |*value|
    drone.turn_left(value[1]) 
  }
  on classic, :rotate_right => proc { |*value|
    drone.turn_right(value[1]) 
  }
end

def init_settings
  @toggle_camera = 0
end
