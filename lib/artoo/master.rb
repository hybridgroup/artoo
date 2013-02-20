module Artoo
  # The Artoo::Master class is a registered supervisor class to keep track
  # of all the running robots
  class Master
    include Celluloid
		attr_reader :robots

    def initialize(bots)
      @robots = bots
    end

    def get_robot_by_name(name)
    	robots.find_all {|r| r.name == name}.first
    end
  end
end