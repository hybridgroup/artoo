module Artoo
	class Connection
		include Celluloid
		attr_reader :parent, :name, :type, :port

		def initialize(params={})
			@name = params[:name].to_s
			@type = params[:type]
			@port = params[:port]
			@parent = params[:parent]

			connect
		end

		def connect
			# TODO: require the needed connector file based on type
		end

		def disconnect
			
		end
	end
end