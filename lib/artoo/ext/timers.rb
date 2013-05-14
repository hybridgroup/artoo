# Monkeypatches for Timers & Timer classes used by Celluloid
class Timers
  def initialize
    @timers = SortedSet.new
    @paused_timers = SortedSet.new
  end

  def pause(timer = nil)
    return pause_all if timer.nil?
    raise TypeError, "not a Timers::Timer" unless timer.is_a? Timers::Timer
    @timers.delete timer
    @paused_timers.add timer
  end

  def pause_all
    @timers.each {|timer| timer.pause}
  end

  def continue(timer = nil)
    return continue_all if timer.nil?
    raise TypeError, "not a Timers::Timer" unless timer.is_a? Timers::Timer
    @paused_timers.delete timer
    @timers.add timer
  end

  def continue_all
    @paused_timers.each {|timer| timer.continue}
  end

  class Timer
    # Pause this timer
    def pause
      @timers.pause self
    end

    # Continue this timer
    def continue
      @timers.continue self
    end
  end
end
