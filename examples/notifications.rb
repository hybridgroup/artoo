require 'artoo'

connection :loop
device :counter, :driver => :counter

work do
  puts 'Starting...'
  on counter, :count => proc {puts 'I am awesome!'}
end
