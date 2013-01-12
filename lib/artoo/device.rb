module Artoo
	class Device
		include Celluloid
		attr_reader :parent, :name, :driver, :pin, :connection

		def initialize(params={})
			@name = params[:name].to_s
			@driver = params[:driver]
			@pin = params[:pin]
			@parent = params[:parent]
			@connection = params[:connection] || default_connection
		end

		def default_connection
			@connection = parent.default_connection
		end
	end
end