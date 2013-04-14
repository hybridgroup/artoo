require 'artoo'

connection :roomba, :adaptor => :roomba, :port => '8023'
device :roomba, :driver => :roomba, :connection => :roomba

connection :arduino, :adaptor => :firmata, :port => '8024'
device :wiichuck, :driver => :wiichuck, :connection => :arduino, :interval => 0.1
  
work do
  roomba.safe_mode
  on wiichuck, :z_button => proc { roomba.beep }
  on wiichuck, :joystick => proc { |*value|

    pair = value[1]

    if pair[:y] > 10
      roomba.forward(1)
    elsif pair[:y] < -10
      roomba.backwards(1)
    end

    if pair[:x] > 10
      roomba.turn_right
    elsif pair[:x] < -10
      roomba.turn_left
    end

  }
end
