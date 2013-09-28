module Artoo
  module Adaptors
    module IO
      class I2c
        attr_reader :handle, :address, :i2c_location

        I2C_SLAVE = 0x0703

        def initialize(i2c_location, address)
          @i2c_location = i2c_location
          start(address)
        end

        def start(address)
          @address = address
          @handle = File.open(@i2c_location, 'r+')
          @handle.ioctl(I2C_SLAVE, @address)

          write 0
        end

        def write(*data)
          ret = ""
          ret.force_encoding("US-ASCII")
          data.each do |n|
            ret << [n].pack("v")[0]
            ret << [n].pack("v")[1]
          end
          @handle.write(ret)
        end

        def read(len)
          begin
            @handle.read_nonblock(len).unpack("C#{len}")
          rescue Exception => e
            start(@address)
          end
        end
      end
    end
  end
end
