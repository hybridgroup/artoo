require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Roomba driver behaviors
    class Roomba < Driver
      
      STRAIGHT = 32768
      CLOCKWISE = 65535
      COUNTERCLOCKWISE = 1
      MAX = 500
      SLOW = 250
      NEG = (65536 - 250)
      ZERO = 0
  
      B = 95
      D = 98
      G = 91
      C = 96
      A = 93
      QUART = 16
      HALF = 57
      WHOLE = 114
      START = 128
      
      module Modes
        FULL = 132
        SAFE = 131
      end
      
      def start
        send_bytes(START)
        sleep 0.2
      end
      
      def safe_mode
        start
        send_bytes(Modes::SAFE)
        sleep 0.1
      end
      
      def full_mode
        start
        send_bytes(Modes::FULL)
        sleep 0.1
      end
      
      def forward(seconds, velocity = SLOW)
        drive(velocity,STRAIGHT,seconds)
        stop if seconds > 0
      end
  
      def stop
        drive(ZERO,STRAIGHT)
      end
  
      def fast_forward(seconds)
        drive(MAX,STRAIGHT,seconds)
        stop if seconds > 0
      end
  
      def backwards(seconds)
        drive(NEG,STRAIGHT,seconds)
        stop if seconds > 0
      end
  
      def nudge_left
        turn_left(0.25)
      end
  
      def turn_left(seconds = 1)
        drive(SLOW,COUNTERCLOCKWISE,seconds)
        stop if seconds > 0
      end
  
      def turn_right(seconds = 1)
        drive(SLOW,CLOCKWISE,seconds)
        stop if seconds > 0
      end
  
      def nudge_right
        turn_right(0.25)
      end
  
      def turn_around
        turn_left(1.6)
      end
  
      def beep
        notes = [140,0,1,G,WHOLE]
        connection.send_bytes(notes)
        connection.send_bytes([141,0])
      end
  
      def sing_jingle_bells
        song0 = [[B,QUART],[B,QUART],[B,HALF],
                [B,QUART],[B,QUART],[B,HALF],
                [B,QUART],[D,QUART],[G,QUART],[A,QUART],
                [B,WHOLE]]
        song1 = [[C,QUART],[C,QUART],[C,QUART],[C,QUART],
                [C,QUART],[B,QUART],[B,HALF],
                [B,QUART],[A,QUART],[A,QUART],[B,QUART],
                [A,HALF],[D,HALF]]
        song2 = [[B,QUART],[B,QUART],[B,HALF],
                [B,QUART],[B,QUART],[B,HALF],
                [B,QUART],[D,QUART],[G,QUART],[A,QUART],
                [B,WHOLE]]
        song3 = [[C,QUART],[C,QUART],[C,QUART],[C,QUART],
                [C,QUART],[B,QUART],[B,QUART],[B,QUART],
                [D,QUART],[D,QUART],[C,QUART],[A,QUART],
                [G,WHOLE]]
            
        note_group = song0.flatten.compact
        l = note_group.length / 2
        notes = [140,0,l] + note_group
        connection.send_bytes(notes)
    
        note_group = song1.flatten.compact
        l = note_group.length / 2
        notes = [140,1,l] + note_group
        connection.send_bytes(notes)
    
        note_group = song2.flatten.compact
        l = note_group.length / 2
        notes = [140,2,l] + note_group
        connection.send_bytes(notes)
    
        note_group = song3.flatten.compact
        l = note_group.length / 2
        notes = [140,3,l] + note_group
        connection.send_bytes(notes)
    
        connection.send_bytes([141,0])
        sleep(7)
        connection.send_bytes([141,1])
        sleep(7)
        connection.send_bytes([141,2])
        sleep(7)
        connection.send_bytes([141,3])
      end
      
      def drive(v,r,s = 0)
        vH,vL = split_bytes(v)
        rH,rL = split_bytes(r)
        connection.send_bytes([137,vH,vL,rH,rL])
        sleep(s) if s > 0
      end
      
      def split_bytes(num)
        [num >> 8, num & 255]
      end
      
    end
  end
end