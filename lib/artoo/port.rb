module Artoo
  # The Artoo::Port class represents port and/or host to be used to connect 
  # tp a specific individual hardware device.
  class Port
    attr_reader :port, :host

    def initialize(data)
      @is_tcp, @is_serial = false
      parse(data)
    end

    def is_serial?
      @is_serial == true
    end

    def is_tcp?
      @is_tcp == true
    end

    def to_s
      if is_serial?
        port
      else
        "#{host}:#{port}"
      end  
    end

    private

    def parse(data)
      # is TCP host/port?
      if m = /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d{1,5})/.match(data)
        @port = m[2]
        @host = m[1]
        @is_tcp = true

      # is it a numeric port for localhost tcp?
      elsif /^[0-9]{1,5}$/.match(data)
        @port = data
        @host = "localhost"
        @is_tcp = true

      # must be a serial port
      else
        @port = data
        @host = nil
        @is_serial = true
      end
    end
  end
end