require 'artoo'

# connection :ardrone, :adaptor => :ardrone, :port => '192.168.1.1:5556'
# device :drone, :driver => :ardrone, :connection => :ardrone

connection :videodrone, :adaptor => :ardrone_video, :port => '192.168.1.1:5555'
device :video, :driver => :ardrone_video, :connection => :videodrone

work do
  on video, :frame => :v_frame
  # drone.start
  # drone.take_off
  # sleep 10
  # drone.hover.land
  # sleep 10
  # drone.stop
end

def v_frame(*data)
  p "frame:"
  puts data[1]
end