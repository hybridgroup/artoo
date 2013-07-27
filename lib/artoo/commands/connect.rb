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
      option :radio, :default => "hci0", :desc => "Bluetooth radio address"
      def bind(address, name)
        case os
        when :linux
          run("rfcomm -i #{options[:radio]} bind /dev/rfcomm#{options[:comm]} #{address} 1")
          run("sudo ln -s /dev/rfcomm#{options[:comm]} /dev/#{name}")
        when :macosx
          say "OSX binds devices on its own volition."
        else
          say "OS not yet supported..."
        end
      end

      desc "socat", "socat [PORT] [NAME] use socat to connect a socket to a serial device by name"
      option :retries, :default => 0, :desc => "Number of times to retry connecting on failure"
      def socat(port, name)
        attempts = 1 + options[:retries].to_i
        
        case os
        when :linux
          run("sudo chmod a+rw /dev/#{name}")
          
          while(attempts > 0) do
            run("socat -d -d FILE:/dev/#{name},nonblock,raw,b115200,echo=0 TCP-LISTEN:#{port},fork")
            break unless $? == 1
            attempts -= 1
          end

        when :macosx
          while(attempts > 0) do
            run("socat -d -d FILE:/dev/#{name},nonblock,raw,echo=0 TCP-LISTEN:#{port},fork")
            break unless $? == 1
            attempts -= 1
          end

        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
