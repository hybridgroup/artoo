require 'artoo/robot'

#SPHEROS = ["4567", "4568", "4569", "4570", "4571"]
SPHEROS = {"4560" => "/dev/tty.Sphero-BRG-RN-SPP",
           "4561" => "/dev/tty.Sphero-YBW-RN-SPP",
           "4562" => "/dev/tty.Sphero-BWY-RN-SPP",
           "4563" => "/dev/tty.Sphero-YRR-RN-SPP",
           "4564" => "/dev/tty.Sphero-OBG-RN-SPP",
           "4565" => "/dev/tty.Sphero-GOB-RN-SPP",
           "4566" => "/dev/tty.Sphero-PYG-RN-SPP"}
           
class SpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  work do
    @count = 1
    every(3.seconds) do
      sphero.set_color(@count % 2 == 0 ? :green : :red)
      @count += 1
      sphero.roll 90, rand(360)
    end
  end
end

robots = []
SPHEROS.each_key {|p|
  robots << SpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

SpheroRobot.work!(robots)
