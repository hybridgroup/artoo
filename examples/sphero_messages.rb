require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
device :sphero, :driver => :sphero
  
work do
  puts "Configuring..."
  sphero.detect_collisions

  every(3.seconds) do
    puts "Rolling..."
    sphero.roll 90, rand(360)
    unless sphero.collisions.empty?
      puts "----------"
      sphero.collisions.each do |c|
        puts c
      end
      puts "=========="
      sphero.async_messages.clear
    end
  end
end