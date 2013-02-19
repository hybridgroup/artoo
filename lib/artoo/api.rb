require 'reel'

module Artoo
	class Api
		include Reel::App

		get '/' { [200, {}, "hello world" }
	end
end

