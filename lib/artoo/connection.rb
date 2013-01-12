module Artoo
	class Connection
		include Celluloid
		attr_reader :parent, :name, :protocol, :port

		def initialize(params={})
			@name = params[:name].to_s
			@protocol = params[:protocol]
			@port = params[:port]
			@parent = params[:parent]
		end
	end
end