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

  on classic, :left_joystick => proc { |*value|
    pair = value[1]
    if pair[:y] > 0
      drone.forward(validate_pitch(pair[:y], @offsets[:ly]))
    elsif pair[:y] < 0
      drone.backward(validate_pitch(pair[:y], @offsets[:ly]))
    else
      drone.forward(0.0)
    end

    if pair[:x] > 0
      drone.right(validate_pitch(pair[:x], @offsets[:lx]))
    elsif pair[:x] < 0
      drone.left(validate_pitch(pair[:x], @offsets[:lx]))
    else
      drone.right(0.0)
    end
  }

  on classic, :right_joystick => proc { |*value|
    pair = value[1]
    if pair[:y] > 0
      drone.up(validate_pitch(pair[:y], @offsets[:ry]))
    elsif pair[:y] < 0
      drone.down(validate_pitch(pair[:y], @offsets[:ry]))
    else
      drone.up(0.0)
    end
  }

  on classic, :right_trigger => proc { |*value|
    if value[1] > 0
      drone.turn_right(validate_pitch(value[1], @offsets[:rt]))
    else
      drone.turn_right(0.0)
    end
  }

  on classic, :left_trigger => proc { |*value|
    if value[1] > 0
      drone.turn_left(validate_pitch(value[1], @offsets[:lt]))
    else
      drone.turn_left(0.0)
    end
  }
end

def init_settings
  @toggle_camera = 0
  @offsets = {
    :ry => 12.0,
    :ly => 27.0,
    :lx => 27.0,
    :rt => 27.0,
    :lt => 12.0
  }
end

def validate_pitch(data, offset)
  value = data.abs / offset
  value >= 0.1 ? (value <= 1.0 ? value.round(2) : 1.0) : 0.0
end
