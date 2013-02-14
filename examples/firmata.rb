require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '4567' #/dev/tty.usbserial-A700636n'
device :board
device :led, :driver => :led, :pin => 13

work do
  puts "Firmware name #{board.firmware_name}"
  puts "Firmata version #{board.version}"
  every 1.second do
    led.on
    board.delay 1

    led.off
    board.delay 1
  end
end
