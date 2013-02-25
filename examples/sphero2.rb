require 'artoo/robot'
           
class SpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  work do
    @count = 1
    every(3.seconds) do
      sphero.set_color(@count % 2 == 0 ? :green : :blue)
      @count += 1
      sphero.roll 90, rand(360)
    end
  end
end

SPHEROS = {"127.0.0.1:4560" => "/dev/tty.Sphero-BRG-RN-SPP",
           "127.0.0.1:4561" => "/dev/tty.Sphero-YBW-RN-SPP"}
robots = []
SPHEROS.each_key {|p|
  robots << SpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

SpheroRobot.work!(robots)
