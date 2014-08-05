module Artoo
  # The Artoo::Master class is a registered supervisor class to keep track
  # of all the running robots
  class Master
    include Celluloid
    attr_reader :robots

    class << self
      def current
        Celluloid::Actor[:master] ||= self.new
      end

      def assign(bots=[])
        current.assign(bots)
      end

      def robots
        current.robots
      end

      def robot(name)
        current.robot(name)
      end

      def start_work
        current.start_work
      end

      def stop_work
        current.stop_work
      end

      def pause_work
        current.pause_work
      end

      def continue_work
        current.continue_work
      end

      def commands
        current.commands
      end

      def add_command(name, method)
        current.add_command(name, method)
      end
    end

    # Create new master
    # @param [Collection] robots
    def initialize(bots=[])
      @robots = []
      @commands = {}
      assign(bots)
    end

    # Assign robots to Master controller
    # @param [Collection] robots
    def assign(bots=[])
      robots.concat(bots)
      bots.each {|r| r.async.work} if Artoo::Robot.is_running?
    end

    # @param  [String] name
    # @return [Robot]  robot
    def robot(name)
      robots.find {|r| r.name == name}
    end

    # Do asynchronous work for each robot
    def start_work
      robots.each {|r| r.async.work} unless Artoo::Robot.is_running?
      Artoo::Robot.running!
    end

    # Pause work for each robot
    def pause_work
      robots.each {|r|
        Logger.info "pausing #{r.name}"
        r.async.pause_work
      }
    end

    # Continue work for each robot
    def continue_work
      robots.each {|r| r.async.continue_work}
    end

    # terminate all robots
    def stop_work
      robots.each {|r| r.terminate} unless !Artoo::Robot.is_running?
      Artoo::Robot.stopped!
    end

    # Return all commands
    def commands
      @commands
    end

    # add command to master
    def add_command(name, method)
      commands[name.to_s] = method
    end
  end
end
