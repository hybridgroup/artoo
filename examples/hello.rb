require 'artoo'

connection :loop

#device :collision_detect, :driver => :switch, :pin => 3
#device :motor, :driver => :l293_motor, :pin => 4
  
work do
  every(3) do
     puts "hello"
  end
  after(10) do
  	puts "wow"
  end
end