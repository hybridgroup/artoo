require 'artoo'

connection :loop
device :passthru
api :host => '127.0.0.1', :port => '4321'

work do
	puts "Hello from the API running at #{api_host}:#{api_port}..."
end