require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Install < Thor
      include Thor::Actions
      include Artoo::Utility
      
      desc "socat", "install socat utility program"
      def socat
        case os 
        when :linux
          run("sudo apt-get update && sudo apt-get install socat")
        when :macosx
          Bundler.with_clean_env do
            run("brew install socat")
          end
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
