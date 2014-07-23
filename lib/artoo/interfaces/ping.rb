require 'artoo/interfaces/interface'

module Artoo
  module Interfaces
    # The Ping interface.
    class Ping < Interface
			COMMANDS = [:ping]

			def ping
			end
    end
  end
end
