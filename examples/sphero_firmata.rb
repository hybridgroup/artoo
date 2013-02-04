require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/tty.Sphero-BWY-RN-SPP'
device :sphero, :connection => :sphero

connection :firmata, :adaptor => :firmata, :port => '/dev/tty.usbserial-A700636n'
device :arduino, :connection => :firmata

work do
  @counter = 0

  every 3.seconds do
    sphero.roll 60, rand(360)
  end

  every 1.second do
    arduino.digital_write(13, high_or_low)
    @counter += 1
  end
end

def high_or_low
  @counter.even? ? Firmata::Board::HIGH : Firmata::Board::LOW
end