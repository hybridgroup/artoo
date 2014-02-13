require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Scan < Commands
      package_name "scan"

      desc "serial", "Scan for connected serial devices"
      def serial
        case os
        when :linux
          run("ls /dev/tty*")
        when :macosx
          run("ls /dev/{tty,cu}.*")
        else
          say("OS not yet supported...")
        end
      end

      desc "usb", "Scan for connected usb devices"
      def usb
        case os
        when :linux
          run("lsusb")
        else
          say "OS not yet supported..."
        end
      end

      desc "bluetooth", "Scan for bluetooth devices"
      def bluetooth
        case os
        when :linux
          run("hcitool scan")
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
