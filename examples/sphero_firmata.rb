require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/tty.Sphero-BRG-RN-SPP'
device :sphero, :driver => :sphero, :connection => :sphero

connection :arduino, :adaptor => :firmata, :port => '/dev/cu.usbserial-A700636n'
device :led, :driver => :led, :connection => :arduino, :pin => 13

work do
  every 3.seconds do
    sphero.roll 60, rand(360)
  end

  every 1.second do
    led.toggle
  end
end
