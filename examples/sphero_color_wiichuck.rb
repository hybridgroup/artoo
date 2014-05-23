require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/rfcomm0' #linux
device :sphero, :driver => :sphero

connection :arduino, :adaptor => :firmata, :port => '/dev/ttyACM0' #linux
device :wiichuck, :driver => :wiichuck, :connection => :arduino, :interval => 0.1
  
work do
  init_settings

  on wiichuck, :joystick => proc { |*value|
    @heading = heading(value[1])
  }

  every(1.seconds) do
  	puts "Rolling..."
    sphero.set_color(rand(255),rand(255),rand(255))
    sphero.roll 20, @heading
  end
end

def init_settings
  sphero.stop
  @heading = 0
end

def heading(value)
  (180.0 - (Math.atan2(value[:y],value[:x]) * (180.0 / Math::PI))).round
end
