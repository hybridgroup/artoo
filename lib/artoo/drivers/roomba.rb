require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The Roomba driver behaviors
    class Roomba < Driver

      COMMANDS = [:start, :safe_mode, :full_mode, :forward, :stop, :fast_forward,
                  :backwards, :nudge_left, :nudge_right, :turn_left, :turn_right,
                  :turn_around, :drive, :play, :song, :beep].freeze

      # Sets Direction constant values
      module Direction
        STRAIGHT = 32768
        CLOCKWISE = 65535
        COUNTERCLOCKWISE = 1
      end

      # Sets speed constant values
      module Speed
        MAX = 500
        SLOW = 250
        NEG = (65536 - 250)
        ZERO = 0
      end

      # Sets notes constant values
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

      # Sets mode constant values
      module Mode
        FULL = 132
        SAFE = 131
        START = 128
      end

      # Sets song constant values
      module Song
        SONG = 140
        PLAY = 141
      end

      # Sends start mode
      def start
        send_bytes(Mode::START)
        sleep 0.2
      end

      # Sends safe mode
      def safe_mode
        start
        send_bytes(Mode::SAFE)
        sleep 0.1
      end

      # Sends full mode
      def full_mode
        start
        send_bytes(Mode::FULL)
        sleep 0.1
      end

      # Move forward
      # @param [Integer] seconds
      # @param [Constant] velocity
      # @see Speed
      def forward(seconds, velocity = Speed::SLOW)
        drive(velocity, Direction::STRAIGHT, seconds)
        stop if seconds > 0
      end

      # Stop movement
      def stop
        drive(Speed::ZERO, Direction::STRAIGHT)
      end

      # Move forward with fast speed
      # @param [Integer] seconds
      def fast_forward(seconds)
        drive(Speed::MAX, Direction::STRAIGHT, seconds)
        stop if seconds > 0
      end

      # Move backward
      # @param [Integer] seconds
      def backwards(seconds)
        drive(Speed::NEG, Direction::STRAIGHT, seconds)
        stop if seconds > 0
      end

      # Nudge left
      def nudge_left
        turn_left(0.25)
      end

      # Turn left
      # @param [Integer] seconds
      def turn_left(seconds = 1)
        drive(Speed::SLOW, Direction::COUNTERCLOCKWISE, seconds)
        stop if seconds > 0
      end

      # Turn right
      # @param [Integer] seconds
      def turn_right(seconds = 1)
        drive(Speed::SLOW, Direction::CLOCKWISE, seconds)
        stop if seconds > 0
      end

      # Nudge right
      def nudge_right
        turn_right(0.25)
      end

      # Turn around
      def turn_around
        turn_left(1.6)
      end

      # Drive
      # @param [Integer] v speed
      # @param [Integer] r direction
      # @param [Integer] s seconds (waiting time)
      # @see Speed
      # @see Direction
      def drive(v, r, s = 0)
        vH,vL = split_bytes(v)
        rH,rL = split_bytes(r)
        send_bytes([137, vH, vL, rH, rL])
        sleep(s) if s > 0
      end

      # Split bytes (hex)
      # @param [Integer] num
      def split_bytes(num)
        [num >> 8, num & 255]
      end

      # Play song
      # @param [Integer] song_number
      def play(song_number = 0)
        send_bytes([Song::PLAY, song_number])
      end

      # Save song
      # @param [Collection] notes
      # @param [Integer]    song_number
      # @see Notes
      def song(notes, song_number = 0)
        note_group = notes.flatten.compact
        l = note_group.length / 2
        send_bytes([Song::SONG, song_number, l] + note_group)
      end

      # Play song
      # @param [Collection] notes
      # @param [Integer]    song_number
      # @see Notes
      def play_song(notes, song_number = 0)
        song(notes, song_number)
        play(song_number)
      end

      # Beeps with a G note
      def beep
        play_song([Note::G, Note::WHOLE])
      end
    end
  end
end
