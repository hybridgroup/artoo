require 'artoo'

connection :sphero, :type => :sphero, :port => '/dev/tty.Sphero-BWY-RN-SPP'
device :sphero
  
work do
  puts "Configuring..."
  sphero.configure_collision_detection 0x01, 0x20, 0x20, 0x20, 0x20, 0x50

  every(3.seconds) do
    puts "Rolling..."
    sphero.roll 60, rand(360)
    unless sphero.async_messages.empty?
      puts "----------"
      while m = sphero.async_messages.shift do
        puts m
      end
      puts "=========="
    end
  end
end