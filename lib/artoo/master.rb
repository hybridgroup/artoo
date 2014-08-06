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
      @robots = {}
      @commands = {}
      assign(bots)
    end

    # Assign robots to Master controller
    # @param [Collection] robots
    def assign(bots=[])
      bots.each do |bot|
        robots[bot.name] = bot
        bot.async.work if Artoo::Robot.is_running?
      end
    end

    # @param  [String] name
    # @return [Robot]  robot
    def robot(name)
      robots[name]
    end

    # Do asynchronous work for each robot
    def start_work
      robots.each_value { |bot| bot.async.work } unless Artoo::Robot.is_running?
      Artoo::Robot.running!
    end

    # Pause work for each robot
    def pause_work
      robots.each_value do |bot|
        Logger.info "pausing #{bot.name}"
        bot.async.pause_work
      end
    end

    # Continue work for each robot
    def continue_work
      robots.each_balue { |bot| bot.async.continue_work }
    end

    # terminate all robots
    def stop_work
      robots.each_value { |bot| bot.terminate } if Artoo::Robot.is_running?
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
