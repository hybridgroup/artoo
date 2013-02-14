require 'artoo'

connection :loop

work do
  every(3.seconds) do
     puts "hello"
  end
  after(10.seconds) do
  	puts "wow"
  end
end