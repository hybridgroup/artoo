require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Roomba driver behaviors
    class Roomba < Driver
      module Direction
        STRAIGHT = 32768
        CLOCKWISE = 65535
        COUNTERCLOCKWISE = 1
      end

      module Speed
        MAX = 500
        SLOW = 250
        NEG = (65536 - 250)
        ZERO = 0
      end

      module Note
        B = 95
        D = 98
        G = 91
        C = 96
        A = 93
        QUARTER = 16
        HALF = 57
        WHOLE = 114
      end

      module Mode
        FULL = 132
        SAFE = 131
        START = 128
      end
      
      def start
        send_bytes(Mode::START)
        sleep 0.2
      end
      
      def safe_mode
        start
        send_bytes(Mode::SAFE)
        sleep 0.1
      end
      
      def full_mode
        start
        send_bytes(Mode::FULL)
        sleep 0.1
      end
      
      def forward(seconds, velocity = Speed::SLOW)
        drive(velocity, Direction::STRAIGHT, seconds)
        stop if seconds > 0
      end
  
      def stop
        drive(Speed::ZERO, Direction::STRAIGHT)
      end
  
      def fast_forward(seconds)
        drive(Speed::MAX, Direction::STRAIGHT, seconds)
        stop if seconds > 0
      end
  
      def backwards(seconds)
        drive(Speed::NEG, Direction::STRAIGHT, seconds)
        stop if seconds > 0
      end
  
      def nudge_left
        turn_left(0.25)
      end
  
      def turn_left(seconds = 1)
        drive(Speed::SLOW, Direction::COUNTERCLOCKWISE, seconds)
        stop if seconds > 0
      end
  
      def turn_right(seconds = 1)
        drive(Speed::SLOW, Direction::CLOCKWISE, seconds)
        stop if seconds > 0
      end
  
      def nudge_right
        turn_right(0.25)
      end
  
      def turn_around
        turn_left(1.6)
      end

      def drive(v, r, s = 0)
        vH,vL = split_bytes(v)
        rH,rL = split_bytes(r)
        send_bytes([137, vH, vL, rH, rL])
        sleep(s) if s > 0
      end
      
      def split_bytes(num)
        [num >> 8, num & 255]
      end
  
      def play(song_number = 0)
        send_bytes([141, song_number])
      end

      def song(notes, song_number = 0)
        note_group = notes.flatten.compact
        l = note_group.length / 2
        send_bytes([140, song_number, l] + note_group)
      end
      
      def play_song(notes, song_number = 0)
        song(notes, song_number)
        play(song_number)
      end

      def beep
        play_song([Note::G, Note::WHOLE])
      end      
    end
  end
end