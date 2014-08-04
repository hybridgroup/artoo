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

      def robot?(name)
        current.robot?(name)
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

      def command(name, params)
        current.command(name, params)
      end

      def add_command(name, behaviour)
        current.add_command(name, behaviour)
      end

      def commands
        current.commands
      end

    end

    # Create new master
    # @param [Collection] robots
    def initialize(bots=[])
      @robots = []
      @commands = []
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

    def robot?(name)
      robots.find {|r| r.name == name}
    end

    # @param  [String]     name
    # @return [Collection] robot devices
    def robot_devices(name)
      robot(name).devices
    end

    # @param  [String] name
    # @param  [String] device_id
    # @return [Device] robot device
    def robot_device(name, device_id)
      robot_devices(name)[device_id.intern]
    end

    # @param  [String]     name
    # @return [Collection] robot connections
    def robot_connections(name)
      robot(name).connections
    end

    # @param  [String] robot_id
    # @param  [String] connection_id
    # @return [Device] robot connection
    def robot_connection(robot_id, connection_id)
      robot_connections(robot_id)[connection_id.intern]
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

    # return list of master command names
    def commands
      @commands.map{ |c| c[:name] }
    end

    # execute master command
    def command(name, params)
      command = @commands.find{ |c| c[:name] == name.to_sym }
      if command
        if params.nil?
          command[:behaviour].call
        else
          command[:behaviour].call(params)
        end
      end
    end

    # add command to master
    def add_command(name, behaviour)
      @commands << { name: name.to_sym, behaviour: behaviour }
    end
  end
end
