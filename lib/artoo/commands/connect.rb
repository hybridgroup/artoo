require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Connect < Thor
      include Thor::Actions

      desc "scan", "scan for connected devices"
      def scan
        run("hcitool scan")
      end

      desc "bind", "bind [COMM] [ADDRESS] [NAME] binds a device to some connected hardware"
      def bind(comm, address, name, hcix=nil)
        run("bundle exec ./bin/artoo_bind.sh #{comm} #{address} #{name}")
      end

      desc "socat", "socat [PORT] [NAME] use socat to connect a socket to a device by name"
      def socat(port, name)
        run("bundle exec ./bin/artoo_socat.sh #{port} #{name}")
      end
    end
  end
end
