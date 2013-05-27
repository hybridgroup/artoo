require 'artoo'

connection :ardrone, :adaptor => :ardrone, :port => '192.168.0.43:5556'
device :drone, :driver => :ardrone, :connection => :ardrone

work do
  drone.start
  drone.take_off
  
  after(25.seconds) { drone.hover.land }
  after(30.seconds) { drone.stop }
end
