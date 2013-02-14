require 'artoo/robot'

SPHEROS = ["4567", #"/dev/tty.Sphero-BRG-RN-SPP"
           "4568", #"/dev/tty.Sphero-YBW-RN-SPP"
           "4569", #"/dev/tty.Sphero-BWY-RN-SPP"
           "4570", #"/dev/tty.Sphero-YRR-RN-SPP"
           "4571"] #"/dev/tty.Sphero-WRW-RN-SPP"

class SpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  work do
    every(3.seconds) do
      sphero.roll 90, rand(360)
    end
  end
end

robots = []
SPHEROS.each {|p|
  robots << SpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

SpheroRobot.work!(robots)
