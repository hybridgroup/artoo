module Artoo
	module Connector
		class Connect
			include Celluloid

			attr_reader :parent, :port

			def initialize(params={})
				@parent = params[:parent]
				@port = params[:port]
				@connected = false
			end

			def connect
				@connected = true
			end

			def disconnect
				@connected = false
				true
			end

			def connected?
				@connected
			end
		end
	end
end