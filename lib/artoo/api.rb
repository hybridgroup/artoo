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
	        handle_request(request)
	      when Reel::WebSocket
	        handle_websocket(request)
	      end
	    end
	  end

	  def handle_request(request)
	    request.respond :ok, "Hello, world!"
	  end

	  def handle_websocket(sock)
	    sock << "Hello everyone out there in WebSocket land!"
	    sock.close
	  end
	end
end
