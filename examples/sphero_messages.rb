require 'artoo'

connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
device :sphero, :driver => :sphero

def contact; @contacts += 1; end

work do
  @contacts = 0

  on sphero, :collision => :contact

  every(3.seconds) do
    puts "Rolling..."
    sphero.roll 90, rand(360)
  end
end
