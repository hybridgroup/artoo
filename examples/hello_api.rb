$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'artoo'

connection :loop
device :passthru
api :host => '127.0.0.1', :port => '4321'

work do
  every(3.seconds) do
     puts "hello"
  end
  after(10.seconds) do
  	puts "wow"
  end
end