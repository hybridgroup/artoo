require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wiichuck driver behaviors for Firmata
    class Wiiclassic < Driver
      def address; 0x52; end

      def start_driver
        listener = ->(value) { update(value) }
        connection.on("i2c_reply", listener)

        connection.i2c_config(0)
        connection.i2c_write_request(address, 0x40, 0x00)

        every(interval) do
          connection.i2c_write_request(address, 0x00, 0x00)
          connection.i2c_read_request(address, 6)
          connection.read_and_process
        end

        super
      end

      def update(value)
        data = parse_wiiclassic(value)
        publish("#{parent.name}_a") if data[:a] == 0
        publish("#{parent.name}_b") if data[:b] == 0
        publish("#{parent.name}_x") if data[:x] == 0
        publish("#{parent.name}_y") if data[:y] == 0
      end

      private 

      def decode( x )
        return ( x ^ 0x17 ) + 0x17
      end

      def parse_wiiclassic(data)
        return classic_data{
          :lx => decode(value[:data][0]) & 0x3f,
          :ly => decode(value[:data][1]) & 0x3f,
          :rx => ((decode(value[:data][0]) & 0xC0) >> 2)  | ((decode(value[:data][1]) & 0xC0) >> 4) | (decode(value[:data][2])[7]),
          :ry => decode(value[:data][2]) & 0x1f,
          :lt = ((decode(value[:data][2]) & 0x60) >> 3) | ((decode(value[:data][3]) & 0xE0) >> 6),
          :rt => decode(value[:data][3]) & 0x1f,
          :d_up => decode(value[:data][5])[0],
          :d_down => decode(value[:data][4])[6],
          :D_left => decode(value[:data][5])[1],
          :D_right => decode(value[:data][4])[7],
          :zr => decode(value[:data][5])[2],
          :zl => decode(value[:data][5])[7],
          :a => decode(value[:data][5])[4],
          :b => decode(value[:data][5])[6],
          :x => decode(value[:data][5])[3],
          :y => decode(value[:data][5])[5],
          :+ => decode(value[:data][4])[2],
          :- => decode(value[:data][4])[4],
          :h => decode(value[:data][4])[3],
        }
      end
    end
  end
end
