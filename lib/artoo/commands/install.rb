require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Install < Thor
      include Thor::Actions
      include Artoo::Utility
      
      desc "socat", "install socat utility program"
      def scan
        if os == :linux
          run("sudo apt-get update && sudo apt-get install socat")
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
