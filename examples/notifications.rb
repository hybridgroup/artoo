# require 'artoo'

# connection :loop
# device :pinger, :driver => :pinger

# work do
#   puts 'Starting...'
#   on pinger, :alive => :awesome
# end

# def awesome(*params)
# 	puts 'I am awesome!'
# end

require 'artoo/robot'

class AwesomeRobot < Artoo::Robot
	connection :loop
  device :pinger, :driver => :pinger

	work do
	  puts 'Starting...'
   	on pinger, :alive => :awesome
	end

	def awesome(*params)
		puts 'I am awesome!'
	end	
end

AwesomeRobot.work!