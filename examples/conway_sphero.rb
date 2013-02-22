require 'artoo/robot'

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
    birth

    every(3.seconds) { movement if alive? }
    every(10.seconds) { birthday if alive? }
  end

  def alive?; (@alive == true); end

  def birth
    sphero.detect_collisions
    @age = 0
    life
    movement
  end

  def life
    @alive = true
    sphero.set_color :green
  end

  def death
    puts "Death."
    @alive = false
    sphero.set_color :red
    sphero.stop
    terminate
  end

  def birthday
    @age += 1
    contacts = sphero.collisions.size
    sphero.clear_collisions
    
    puts "Happy birthday, #{name}, you are #{@age} and had #{contacts} contacts."
    #return if @age <= 3
    death unless contacts >= 3 && contacts < 5
  end

  def movement
    sphero.roll 90, rand(360)
  end
end

robots = []
SPHEROS.each_key {|p|
  robots << SpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

SpheroRobot.work!(robots)
