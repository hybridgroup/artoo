module Artoo
	class Robot
		include Celluloid

		def self.work
			puts "Working..."
		end

		def self.device
			puts "Registering device..."
		end
	end
end