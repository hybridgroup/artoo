require 'artoo/robot'

class DroneRobot < Artoo::Robot
  connection :drone, :adaptor => :ardrone
  device :drone, :driver => :ardrone

  #api :host => '127.0.0.1', :port => '8080'

  work do
    drone.start

    after(10.seconds){
      drone.take_off
      drone.hover
    }
    after(15.seconds){
      drone.turn_right(0.3)
    }
    after(25.seconds){
      drone.hover
    }
    after(30.seconds){
      drone.land
    }
  end
end

DRONES = {"192.168.0.43:5556" => "wedge",
           "192.168.0.44:5556" => "biggs"}
robots = []
DRONES.each_key {|p|
  robots << DroneRobot.new(:connections =>
                              {:drone =>
                                {:port => p}})
}

DroneRobot.work!(robots)
