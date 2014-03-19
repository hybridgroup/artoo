module Artoo
  module Commands
    class Socket < Commands

      desc "connect [NAME] [PORT]", "Connect a serial device to a TCP socket using socat"
      option :retries, :aliases => "-r", :default => 0, :desc => "Number of times to retry connecting on failure"
      option :baudrate, :aliases => "-b", :default => 57600, :desc => "Baud rate to use to connect to the serial device"
      def connect(name, port, retries = nil, baudrate = nil)
        retries |= (1 + options[:retries].to_i)
        baudrate |= options[:baudrate].to_i

        # check that Socat is installed
        system("socat -V &> /dev/null")
        unless $?.success?
          say "Socat not installed. Cannot bind serial to TCP."
          say "Please install with 'artoo install socat' and try again."
          return
        end

        case os
        when :linux
          run("sudo chmod a+rw /dev/#{name}")

          while(retries > 0) do
            run("socat -d -d FILE:/dev/#{name},nonblock,raw,b#{ baudrate },echo=0 TCP-LISTEN:#{port},fork")
            break unless $? == 1
            retries -= 1
          end

        when :macosx
          while(retries > 0) do
            run("socat -d -d -b#{ baudrate } FILE:/dev/#{name},nonblock,raw,echo=0 TCP-LISTEN:#{port},fork")
            break unless $? == 1
            retries -= 1
          end

        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
