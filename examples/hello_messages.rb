require 'artoo/robot'

class GreeterRobot < Artoo::Robot
  connection :loop
  
  work do
    every(5.seconds) do
      say 'Hola'
    end
  end

  def say(greeting)
    friend_name = "Number #{rand(5)}"
    puts "Saying '#{greeting}' to #{friend_name}"
    Artoo::Master.robot(friend_name).hello(greeting, current_instance)
  end
end

class MessageRobot < Artoo::Robot
  connection :loop
  
  work do
    every(3.seconds) do
      puts "#{name} is alive..."
    end
  end

  def hello(greeting, sender)
    puts "'#{sender.name}' said '#{greeting}' to #{name}"
  end
end

robots = []
5.times do |i|
  robots << MessageRobot.new(:name => "Number #{i}")
end

robots << GreeterRobot.new(:name => "Greeter")

Artoo::Robot.work!(robots)
