require 'reel'

module Artoo
  class Api < Reel::Server
    def initialize(host = "127.0.0.1", port = 3000)
      super(host, port, &method(:on_connection))
    end

    def on_connection(connection)
      while request = connection.request
        case request
        when Reel::Request
          handle_request(connection, request)
        when Reel::WebSocket
          handle_websocket(connection, request)
        end
      end
    end

    def handle_request(connection, request)
      case request.url
        when "/"; return render_index(connection, request)
        when "/robots"; return render_robots(connection, request)       
      end

      Logger.info "404 Not Found: #{request.path}"
      connection.respond :not_found, "Not found"
    end

    def handle_websocket(connection, sock)
      sock << "Hello everyone out there in WebSocket land!"
      sock.close
    end

    def render_index(connection, request)
      request.respond :ok, "Hello, world!"
    end

    def render_robots(connection, request)
      request.respond :ok, "List of robots goes here..."
    end
  end
end
