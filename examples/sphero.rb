require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '/dev/tty.Sphero-YRR-RN-SPP'
device :sphero
  
work do
  every(3.seconds) do
    sphero.roll 60, rand(360)
  end
end