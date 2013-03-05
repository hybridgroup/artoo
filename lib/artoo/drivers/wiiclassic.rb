require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Wiiclassic driver behaviors for Firmata
    class Wiiclassic < Driver
      attr_reader :joystick

      def address; 0x52; end

      INITIAL_DEFAULTS = {
          :ry_offset => 12.0,
          :ry_origin => nil,
          :ly_offset => 27.0,
          :lx_offset => 27.0,
          :ly_origin => nil,
          :lx_origin => nil,
          :rt_origin => nil,
          :lt_origin => nil,
          :rt_offset => 27.0,
          :lt_offset => 12.0
        }

      def initialize(params={})
        @joystick = INITIAL_DEFAULTS
        super
      end

      def start_driver
        begin
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
          if encrypted?(value)
            Logger.error "Encrypted bytes from wiiclassic!"
            return
          end

          data = parse_wiiclassic(value)
          
          adjust_origins(data)
          update_buttons(data)
          update_left_joystick(data)
          update_right_joystick(data)
          update_rotate(data)

        rescue Exception => e
          Logger.error "wiiclassic update exception!"
          Logger.error e.message
          Logger.error e.backtrace.inspect
        end
      end

      def adjust_origins(data)
        set_joystick_default_value(:ly_origin, data[:ly])
        set_joystick_default_value(:lx_origin, data[:lx])
        set_joystick_default_value(:ry_origin, data[:ry])
        set_joystick_default_value(:rt_origin, data[:rt])
        set_joystick_default_value(:lt_origin, data[:lt])
      end

      def set_joystick_default_value(joystick_axis, default_value)     
        joystick[joystick_axis] = default_value if joystick[joystick_axis].nil?
      end

      def update_buttons(data)
        publish(event_topic_name("a_button")) if data[:a] == 0
        publish(event_topic_name("b_button")) if data[:b] == 0
        publish(event_topic_name("x_button")) if data[:x] == 0
        publish(event_topic_name("y_button")) if data[:y] == 0
        publish(event_topic_name("home_button")) if data[:h] == 0
        publish(event_topic_name("start_button")) if data[:+] == 0
        publish(event_topic_name("select_button")) if data[:-] == 0
      end

      def update_left_joystick(data)
        if data[:ly] > @joystick[:ly_origin]
          publish(event_topic_name("ly_up"), validate_pitch((data[:ly] - @joystick[:ly_origin]) / @joystick[:ly_offset]))
        elsif data[:ly] < @joystick[:ly_origin]
          publish(event_topic_name("ly_down"), validate_pitch((@joystick[:ly_origin] - data[:ly]) / @joystick[:ly_offset]))
        else
          publish(event_topic_name("ly_up"), 0.0)
        end

        if data[:lx] > @joystick[:lx_origin]
          publish(event_topic_name("lx_right"), validate_pitch((data[:lx] - @joystick[:lx_origin]) / @joystick[:lx_offset]))
        elsif data[:lx] < @joystick[:lx_origin]
          publish(event_topic_name("lx_left"), validate_pitch((@joystick[:lx_origin] - data[:lx]) / @joystick[:lx_offset]))
        else
          publish(event_topic_name("lx_right"), 0.0)
        end

      end

      def update_right_joystick(data)
        if data[:ry] > @joystick[:ry_origin]
          publish(event_topic_name("ry_up"), validate_pitch((data[:ry] - @joystick[:ry_origin]) / @joystick[:ry_offset]))
        elsif data[:ry] < @joystick[:ry_origin]
          publish(event_topic_name("ry_down"), validate_pitch((@joystick[:ry_origin] - data[:ry]) / @joystick[:ry_offset]))
        else
          publish(event_topic_name("ry_down"), 0.0)
        end
      end

      def update_rotate(data)
        if data[:rt] > @joystick[:rt_origin]
          publish(event_topic_name("rotate_right"), validate_pitch((data[:rt] - @joystick[:rt_origin]) / @joystick[:rt_offset]))
        elsif data[:lt] > @joystick[:lt_origin]
          publish(event_topic_name("rotate_left"), validate_pitch((data[:lt] - @joystick[:lt_origin]) / @joystick[:lt_offset]))
        else
          publish(event_topic_name("rotate_right"), 0.0)
        end
      end

      private 

      def validate_pitch(value)
        value >= 0.1 ? (value <= 1.0 ? value.round(2) : 1.0) : 0.0
      end

      def encrypted?(value)
        value[:data][0] == value[:data][1] && value[:data][2] == value[:data][3] && value[:data][4] == value[:data][5]
      end

      def decode( x )
        return ( x ^ 0x17 ) + 0x17
      end

      def get_value(value, index)
        decode(value[:data][index])
      end

      def parse_wiiclassic(value)
        return {
          :lx => get_value(value, 0) & 0x3f,
          :ly => get_value(value, 1) & 0x3f,
          :rx => ((get_value(value, 0) & 0xC0) >> 2)  | ((get_value(value, 1) & 0xC0) >> 4) | (get_value(value, 2)[7]),
          :ry => get_value(value, 2) & 0x1f,
          :lt => ((get_value(value, 2) & 0x60) >> 3) | ((get_value(value, 3) & 0xE0) >> 6),
          :rt => get_value(value, 3) & 0x1f,
          :d_up => get_value(value, 5)[0],
          :d_down => get_value(value, 4)[6],
          :D_left => get_value(value, 5)[1],
          :D_right => get_value(value, 4)[7],
          :zr => get_value(value, 5)[2],
          :zl => get_value(value, 5)[7],
          :a => get_value(value, 5)[4],
          :b => get_value(value, 5)[6],
          :x => get_value(value, 5)[3],
          :y => get_value(value, 5)[5],
          :+ => get_value(value, 4)[2],
          :- => get_value(value, 4)[4],
          :h => get_value(value, 4)[3],
        }
      end
    end
  end
end
