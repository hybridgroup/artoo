require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '/dev/ttyACM0' #linux
device :board
device :led, :driver => :led, :pin => 13

work do
  puts "Firmware name #{board.firmware_name}"
  puts "Firmata version #{board.version}"
  every 1.second do
    led.toggle
  end
end
