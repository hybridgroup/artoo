# monkeypatches for Celluloid Actor class
module Celluloid
  def timers
    Actor.timers
  end

  class Actor
    attr_accessor :timers

    class << self
      def timers
        actor = Thread.current[:celluloid_actor]
        raise NotActorError, "not in actor scope" unless actor
        actor.timers
      end
    end
  end
end
