require 'artoo'

connection :loop
device :pinger, :driver => :pinger

work do
  puts 'Starting...'
  on pinger, :alive => proc {puts 'I am awesome!'}
end
