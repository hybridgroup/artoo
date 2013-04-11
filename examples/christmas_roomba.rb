require 'artoo'

connection :roomba, :adaptor => :roomba, :port => '/dev/tty.usbserial-A2001yzl'
device :roomba, :driver => :roomba, :connection => :roomba
  
work do
  roomba.safe_mode
  roomba.nudge_left
  roomba.nudge_right
  roomba.nudge_right
  roomba.nudge_left
  sing_jingle_bells
end

def sing_jingle_bells
  note_group = JingleBells.song0
  l = note_group.length / 2
  notes = [140, 0, l] + note_group
  roomba.send_bytes(notes)

  note_group = JingleBells.song1
  l = note_group.length / 2
  notes = [140, 1, l] + note_group
  roomba.send_bytes(notes)

  note_group = JingleBells.song2
  l = note_group.length / 2
  notes = [140, 2, l] + note_group
  roomba.send_bytes(notes)

  note_group = JingleBells.song3
  l = note_group.length / 2
  notes = [140, 3, l] + note_group
  roomba.send_bytes(notes)

  roomba.send_bytes([141,0])
  sleep(7)
  roomba.send_bytes([141,1])
  sleep(7)
  roomba.send_bytes([141,2])
  sleep(7)
  roomba.send_bytes([141,3])
end

class JingleBells
  include Artoo::Drivers::Roomba::Note

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
