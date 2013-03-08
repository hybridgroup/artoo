require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
device :sphero, :driver => :sphero

connection :arduino, :adaptor => :firmata, :port => "8023"
device :wiichuck, :driver => :wiichuck, :connection => :arduino, :interval => 0.1
  
work do
  init_settings
  on wiichuck, :c_button => proc {}
  on wiichuck, :z_button => proc {}
  on wiichuck, :joystick => proc { |*value|
    @heading = heading(value[1])
  }
  every(1.seconds) do
  	puts "Rolling..."
    sphero.roll 20, @heading
  end
end

def init_settings
  @heading = 0
end

def heading(value)
  (180.0 - (Math.atan2(value[:y],value[:x]) * (180.0 / Math::PI))).round
end
