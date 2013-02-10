require 'artoo/robot'

# SPHEROS = ["/dev/tty.Sphero-BRG-RN-SPP",
#            "/dev/tty.Sphero-YBW-RN-SPP",
#            "/dev/tty.Sphero-BWY-RN-SPP",
#            "/dev/tty.Sphero-YRR-RN-SPP",
#            "/dev/tty.Sphero-WRW-RN-SPP",
#            "/dev/tty.Sphero-GBP-RN-SPP"]

SPHEROS = ["4567",
           "4568",
           "4569",
           "4570",
           "4571"]

class SpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero
  
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
