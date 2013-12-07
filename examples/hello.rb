require 'artoo'

connection :loop

name "Johnny"

work do
  every(3.seconds) do
    puts "Hello. My name is #{name}."
  end

  after(10.seconds) do
    puts "Wow."
  end
end
