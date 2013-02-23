require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wiichuck driver behaviors for Firmata
    class Wiiclassic < Driver
      def address; 0x52; end

      def start_driver
        begin
        @joystick = {
          :ry_offset => 8,
          :ry_origin => nil,
          :ly_offset => 20,
          :lx_offset => 20,
          :ly_origin => nil,
          :lx_origin => nil,
          :rt_origin => nil,
          :lt_origin => nil,
          :rt_offset => 5,
          :lt_offset => 5
        }
        listener = ->(value) { update(value) }
        connection.on("i2c_reply", listener)

        connection.i2c_config(0)
        every(interval) do
          connection.i2c_write_request(address, 0x40, 0x00)
          p
          connection.i2c_write_request(address, 0x00, 0x00)
          p
          connection.i2c_read_request(address, 6)
          p
          connection.read_and_process
        end
        
        super
        rescue Exception => e
          p "start driver"
          p e.message
          p e.backtrace.inspect
        end

      end

      def update(value)
        begin
          #Logger.info "value[:data] #{value[:data].inspect}"
          if value[:data][0] == value[:data][1] && value[:data][2] == value[:data][3] && value[:data][4] == value[:data][5]
          #  Logger.error "Encrypted bytes from wiiclassic"
            break
          end
          data = parse_wiiclassic(value)
          #publish(event_topic_name("_a_button") if data[:a] == 0
          publish(event_topic_name("a_button")) if data[:a] == 0
          publish(event_topic_name("b_button")) if data[:b] == 0
          publish(event_topic_name("x_button")) if data[:x] == 0
          publish(event_topic_name("y_button")) if data[:y] == 0
          publish(event_topic_name("home_button")) if data[:h] == 0
          publish(event_topic_name("start_button")) if data[:+] == 0
          publish(event_topic_name("select_button")) if data[:-] == 0

          @joystick[:ly_origin] = data[:ly] if @joystick[:ly_origin].nil?
          @joystick[:lx_origin] = data[:lx] if @joystick[:lx_origin].nil?

          @joystick[:ry_origin] = data[:ry] if @joystick[:ry_origin].nil?

          @joystick[:rt_origin] = data[:rt] if @joystick[:rt_origin].nil?
          @joystick[:lt_origin] = data[:lt] if @joystick[:lt_origin].nil?

          if data[:ly] > (@joystick[:ly_origin] + @joystick[:ly_offset])
            publish(event_topic_name("ly_up"))
          elsif data[:ly] < (@joystick[:ly_origin] - @joystick[:ly_offset])
            publish(event_topic_name("ly_down"))
          elsif data[:lx] > (@joystick[:lx_origin] + @joystick[:lx_offset])
            publish(event_topic_name("lx_right"))
          elsif data[:lx] < (@joystick[:lx_origin] - @joystick[:lx_offset])
            publish(event_topic_name("lx_left"))
          else
            publish(event_topic_name("reset_pitch_roll"))
          end

          if data[:ry] > (@joystick[:ry_origin] + @joystick[:ry_offset])
            publish(event_topic_name("ry_up"))
          elsif data[:ry] < (@joystick[:ry_origin] - @joystick[:ry_offset])
            publish(event_topic_name("ry_down"))
          else
            publish(event_topic_name("reset_altitude"))
          end

          if data[:rt] > (@joystick[:rt_origin] + @joystick[:rt_offset])
            publish(event_topic_name("rotate_right"))
          elsif data[:lt] > (@joystick[:lt_origin] + @joystick[:lt_offset])
            publish(event_topic_name("rotate_left"))
          else
            publish(event_topic_name("reset_rotate"))
          end

        rescue Exception => e
          p "wiiclassic update exception!"
          p e.message
          p e.backtrace.inspect
        end
      end

      private 

      def decode( x )
        return ( x ^ 0x17 ) + 0x17
      end

      def parse_wiiclassic(value)
        return {
          :lx => decode(value[:data][0]) & 0x3f,
          :ly => decode(value[:data][1]) & 0x3f,
          :rx => ((decode(value[:data][0]) & 0xC0) >> 2)  | ((decode(value[:data][1]) & 0xC0) >> 4) | (decode(value[:data][2])[7]),
          :ry => decode(value[:data][2]) & 0x1f,
          :lt => ((decode(value[:data][2]) & 0x60) >> 3) | ((decode(value[:data][3]) & 0xE0) >> 6),
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
