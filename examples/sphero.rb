require 'artoo'

connection :sphero, :type => :sphero, :port => '/dev/tty.Sphero-BWY-RN-SPP'
device :sphero
  
work do
  every(3.seconds) do
    sphero.roll 60, rand(360)
  end
end