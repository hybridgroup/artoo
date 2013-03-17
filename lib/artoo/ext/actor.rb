# monkeypatches for Celluloid Actor class
module Celluloid
  # Pause all running Celluloid::Timer objects for this actor
  def pause_timers
    Thread.current[:celluloid_actor].pause_timers
  end

  # Continue all paused Celluloid::Timer objects for this actor
  def continue_timers
    Thread.current[:celluloid_actor].continue_timers
  end
    
  class Actor
    # Pause all active timers from running at their appointed times
    def pause_timers
      @timers.pause
    end

    # Continue all paused timers running at their appointed times
    def continue_timers
      @timers.continue
    end
  end
end
