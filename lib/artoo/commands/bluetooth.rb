require 'thor'
require 'thor/group'

module Artoo
  module Commands
    class Bluetooth < Commands
      package_name "bluetooth"

      desc "scan", "Scan for bluetooth devices"
      def scan
        Artoo::Commands::Scan.new().bluetooth()
      end

      desc "bind [ADDRESS] [NAME]", "Binds a Bluetooth device to a serial port"
      option :comm, :aliases => "-c", :default => 0, :desc => "Comm number"
      option :radio, :aliases => "-r", :default => "hci0", :desc => "Bluetooth radio address"
      def bind(address, name)
        case os
        when :linux
          run("sudo rfcomm -i #{options[:radio]} bind /dev/rfcomm#{options[:comm]} #{address} 1")
          run("sudo ln -s /dev/rfcomm#{options[:comm]} /dev/#{name}")
        when :macosx
          say "OSX binds devices on its own volition."
        else
          say "OS not yet supported..."
        end
      end

      desc "unbind [ADDRESS] [NAME]", "Unbinds a Bluetooth device from a serial port"
      def unbind(address, name)
        case os
        when :linux
          run("sudo rfcomm unbind #{address}")
          run("sudo rm /dev/#{name}")
        when :macosx
          say "OSX binds devices on its own volition."
        else
          say "OS not yet supported..."
        end
      end

      desc "connect [NAME] [PORT]", "Connect a serial device to a TCP socket using socat"
      option :retries, :aliases => "-r", :default => 0, :desc => "Number of times to retry connecting on failure"
      option :baudrate, :aliases => "-b", :default => 57600, :desc => "Baud rate to use to connect to the serial device"
      def connect(name, port)
        Artoo::Commands::Socket.new().connect(name, port, options[:retries], options[:baudrate])
      end

      desc "pair [ADDRESS]", "Pairs a Bluetooth device"
      def pair(address)
        case os
        when :linux
          run("bluez-simple-agent hci0 #{ address }")
        when :macosx
          say "OS X manages Bluetooth pairing itself."
        else
          say "OS not yet supported..."
        end
      end

      desc "unpair [ADDRESS]", "Unpairs a Bluetooth device"
      def unpair(address)
        case os
        when :linux
          run("bluez-simple-agent hci0 #{ address } remove")
        when :macosx
          say "OS X manages Bluetooth unpairing itself."
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
