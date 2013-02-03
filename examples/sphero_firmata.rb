require 'artoo'

connection :sphero, :type => :sphero, :port => '/dev/tty.Sphero-BWY-RN-SPP'
device :sphero, :connection => :sphero

connection :firmata, :type => :firmata, :port => '/dev/tty.usbserial-A700636n'
device :firmata, :connection => :firmata

work do
	@counter = 0

  every 3.seconds do
    sphero.roll 60, rand(360)
  end

  every 1.second do
		firmata.digital_write(13, high_or_low)
    @counter += 1
  end
end

def high_or_low
	@counter.even? ? Firmata::Board::HIGH : Firmata::Board::LOW
end