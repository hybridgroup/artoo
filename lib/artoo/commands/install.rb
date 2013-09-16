require 'artoo/utility'
require 'artoo/commands/commands'
require 'fileutils'

module Artoo
  module Commands
    class Install < Commands
      package_name "install"
      
      desc "socat", "Install the socat serial to socket utility program"
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

      desc "command [FILENAME]", "Installs artoo command extension files"
      def command(file)
        empty_directory Install.install_dir
        FileUtils.cp(file, Install.install_dir)
      end
    end
  end
end
