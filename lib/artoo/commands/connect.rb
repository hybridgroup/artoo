require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Connect < Thor
      include Thor::Actions
      include Artoo::Utility
      
      desc "scan", "scan for connected devices"
      def scan
        if os == :linux
          run("hcitool scan")
        else
          say "OS not yet supported..."
        end
      end

      desc "bind", "bind [COMM] [ADDRESS] [NAME] binds a device to some connected hardware"
      def bind(comm, address, name, hcix=nil)
        if os == :linux
          run("bundle exec ./bin/artoo_bind.sh #{comm} #{address} #{name}")
        else
          say "OS not yet supported..."
        end
      end

      desc "socat", "socat [PORT] [NAME] use socat to connect a socket to a device by name"
      def socat(port, name)
        if os == :linux
          run("bundle exec ./bin/artoo_socat.sh #{port} #{name}")
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
