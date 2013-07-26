require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Connect < Thor
      include Thor::Actions
      include Artoo::Utility

      desc "scan", "scan for connected devices"
      def scan
        case os
        when :linux
          run("hcitool scan")
        when :macosx
          run("ls /dev/tty.*")          
        else
          say "OS not yet supported..."
        end
      end

      desc "bind", "bind [ADDRESS] [NAME] binds a device to some connected hardware"
      option :comm, :default => 0, :desc => "Comm number"
      def bind(address, name, hcix=nil)
        case os
        when :linux
          run("bundle exec ./bin/artoo_bind.sh #{options[:comm]} #{address} #{name}")
        when :macosx
          say "OSX binds devices on its own volition."
        else
          say "OS not yet supported..."
        end
      end

      desc "socat", "socat [PORT] [NAME] use socat to connect a socket to a device by name"
      def socat(port, name)
        case os
        when :linux
          run("bundle exec ./bin/artoo_socat_linux.sh #{port} #{name}")
        when :macosx
          run("bundle exec ./bin/artoo_socat_osx.sh #{port} #{name}")          
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
