require 'artoo'
require 'artoo/drivers/roomba'

connection :roomba, :adaptor => :roomba, :port => '/dev/ttyUSB0'
device :roomba, :driver => :roomba, :connection => :roomba
  
work do
  roomba.safe_mode
  roomba.nudge_left
  roomba.nudge_right
  roomba.nudge_right
  roomba.nudge_left
  play_jingle_bells
end

def play_jingle_bells
  roomba.song(JingleBells.song0, 0)
  roomba.song(JingleBells.song1, 1)
  roomba.song(JingleBells.song2, 2)
  roomba.song(JingleBells.song3, 3)

  roomba.play(0)
  sleep(7)
  roomba.play(1)
  sleep(7)
  roomba.play(2)
  sleep(7)
  roomba.play(3)
end

class JingleBells
  extend Artoo::Drivers::Roomba::Note

  class << self
    def song0
      [[B, QUARTER], [B, QUARTER], [B, HALF],
       [B, QUARTER], [B, QUARTER], [B, HALF],
       [B, QUARTER], [D, QUARTER], [G, QUARTER], [A, QUARTER],
       [B, WHOLE]]
    end

    def song1
      [[C, QUARTER], [C, QUARTER], [C, QUARTER], [C, QUARTER],
       [C, QUARTER], [B, QUARTER], [B, HALF],
       [B, QUARTER], [A, QUARTER], [A, QUARTER], [B, QUARTER],
       [A, HALF], [D, HALF]]
    end

    def song2
      [[B, QUARTER], [B, QUARTER], [B, HALF],
       [B, QUARTER], [B, QUARTER], [B, HALF],
       [B, QUARTER], [D, QUARTER], [G, QUARTER], [A, QUARTER],
       [B, WHOLE]]
    end

    def song3
      [[C, QUARTER], [C, QUARTER], [C, QUARTER], [C, QUARTER],
       [C, QUARTER], [B, QUARTER], [B, QUARTER], [B, QUARTER],
       [D, QUARTER], [D, QUARTER], [C, QUARTER], [A, QUARTER],
       [G, WHOLE]]
    end
  end
end
