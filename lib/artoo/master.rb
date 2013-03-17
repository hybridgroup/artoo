module Artoo
  # The Artoo::Master class is a registered supervisor class to keep track
  # of all the running robots
  class Master
    include Celluloid
		attr_reader :robots

    def initialize(bots)
      @robots = bots
    end

    def robot(name)
      robots.find {|r| r.name == name}
    end

    def robot_devices(name)
      robot(name).devices
    end

    def robot_device(name, device_id)
      robot_devices(name)[device_id.intern]
    end

    def robot_connections(name)
      robot(name).connections
    end

    def robot_connection(robot_id, connection_id)
      robot_connections(robot_id)[connection_id.intern]
    end

    def start_work
      robots.each {|r| r.async.work} unless Artoo::Robot.is_running?
    end

    def pause_work
      #robots.each {|r| r.async.pause_work}
    end

    def continue_work
      #robots.each {|r| r.async.continue_work}
    end

    def stop_work
      #robots.each {|r| r.async.stop_work} unless !Artoo::Robot.is_running?
    end
  end
end