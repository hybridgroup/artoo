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
  
      B = 95.chr
      D = 98.chr
      G = 91.chr
      C = 96.chr
      A = 93.chr
      QUART = 16.chr
      HALF = 57.chr
      WHOLE = 114.chr
      
      def forward(args)
        seconds = args[0].to_i
        velocity = (args[1]) ? args[1].to_i : SLOW
        drive(velocity,STRAIGHT,seconds)
        stop if seconds > 0
      end
  
      def stop
        drive(ZERO,STRAIGHT)
      end
  
      def fast_forward(args)
        seconds = args[0].to_i
        drive(MAX,STRAIGHT,seconds)
        stop if seconds > 0
      end
  
      def backwards(args)
        seconds = args[0].to_i
        drive(NEG,STRAIGHT,seconds)
        stop if seconds > 0
      end
  
      def nudge_left
        turn_left(0.25)
      end
  
      def turn_left(s = 1)
        drive(SLOW,COUNTERCLOCKWISE,s)
        stop if seconds > 0
      end
  
      def turn_right(s = 1)
        drive(SLOW,CLOCKWISE,s)
        stop if seconds > 0
      end
  
      def nudge_right
        turn_right(0.25)
      end
  
      def turn_around
        turn_left(1.6)
      end
  
      def beep
        notes = [140.chr,0.chr,1.chr,G,WHOLE]
        connection.send_bytes(notes)
        connection.send_bytes([141.chr,0.chr])
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
        notes = [140.chr,0.chr,l.chr] + note_group
        connection.send_bytes(notes)
    
        note_group = song1.flatten.compact
        l = note_group.length / 2
        notes = [140.chr,1.chr,l.chr] + note_group
        connection.send_bytes(notes)
    
        note_group = song2.flatten.compact
        l = note_group.length / 2
        notes = [140.chr,2.chr,l.chr] + note_group
        connection.send_bytes(notes)
    
        note_group = song3.flatten.compact
        l = note_group.length / 2
        notes = [140.chr,3.chr,l.chr] + note_group
        connection.send_bytes(notes)
    
        connection.send_bytes([141.chr,0.chr])
        sleep(7)
        connection.send_bytes([141.chr,1.chr])
        sleep(7)
        connection.send_bytes([141.chr,2.chr])
        sleep(7)
        connection.send_bytes([141.chr,3.chr])
      end
      
      def drive(v,r,s = 0)
        vH,vL = split_bytes(v)
        rH,rL = split_bytes(r)
        connection.send_bytes([137.chr,vH.chr,vL.chr,rH.chr,rL.chr])
        sleep(s) if s > 0
      end
      
      def execute(data)
        args = data.split(" ")
        cmd = args.shift
        unless args.empty?
          connection.send(cmd,args)
        else
          connection.send(cmd)
        end
      end
      
      def split_bytes(num)
        [num >> 8, num & 255]
      end
      
    end
  end
end