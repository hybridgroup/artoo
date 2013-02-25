require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :led, :driver => :led, :pin => 13

work do
  puts "Firmware name #{board.firmware_name}"
  puts "Firmata version #{board.version}"
  every 1.second do
    led.toggle
  end
end
