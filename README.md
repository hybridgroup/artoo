# artoo

Micro-framework for robotics using Ruby

## Examples:

### Basic

```
require 'artoo'

connection :arduino, :connector => :firmata, :port => '/dev/tty.usbmodemxxxxx'

device :collision_detect, :driver => :switch, :pin => 3
device :motor, :driver => :l293_motor, :pin => 4
  
work do
  every 10.seconds do
    motor.forward until collision_detect?
  end
end
```

### Modular

```
require 'artoo/robot'
 
class Huey < Artoo::Robot
  connection :arduino, :connector => :firmata, :port => '/dev/tty.usbmodemxxxxx'

  device :motion_detect, :driver => :motion_detector, :pin => 7
  device :temp, :driver => :thermometer, :pin => 8
  
  device :motor_1, :driver => :l293_motor, :pin => 3
  device :motor_2, :driver => :l293_motor, :pin => 4
  
  work do
    every 30.seconds do
      forward 10, 3.seconds
    end
    
    every 3.seconds do
      if temp > 80 and motion_detect?
        take_evasive_action!
      end
    end
  end
  
  def forward(speed, duration)
    motor_1.forward speed, duration
    motor_2.forward speed, duration
  end
  
  def left(speed, duration)
    motor_1.forward speed / 2, duration
    motor_2.forward speed, duration
  end
  
  def right(speed, duration)
    motor_1.forward speed, duration
    motor_2.forward speed / 2, duration
  end
  
  def backward(speed, duration)
    motor_1.backward speed, duration
    motor_2.backward speed, duration
  end
  
  def take_evasive_action!
    backward 10, 3.seconds
    left 10, 1.second
    right 10, 3.seconds
  end
end
```

## Installing:

```
gem install artoo
```

## Running:

```
ruby myrobot.rb
```

