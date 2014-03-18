module Artoo
  module Commands
    class Socket < Commands

      def connect(name, port, retries, baudrate)
        attempts = 1 + retries.to_i

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

          while(attempts > 0) do
            run("socat -d -d FILE:/dev/#{name},nonblock,raw,b#{ baudrate },echo=0 TCP-LISTEN:#{port},fork")
            break unless $? == 1
            attempts -= 1
          end

        when :macosx
          while(attempts > 0) do
            run("socat -d -d -b#{ baudrate } FILE:/dev/#{name},nonblock,raw,echo=0 TCP-LISTEN:#{port},fork")
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
