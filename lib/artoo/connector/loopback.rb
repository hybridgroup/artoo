module Artoo
	module Connector
		class Loopback
			include Celluloid

			attr_reader :parent, :port

			def initialize(params={})
				@parent = params[:parent]
				@port = params[:port]
			end

			def connect
				true
			end

			def disconnect
				true
			end
		end
	end
end