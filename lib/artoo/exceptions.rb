module Artoo
  class RobotNotFound < StandardError; end # unable to find a robot by name in master
  class InvalidPin < StandardError; end # this pin is not validd for this operation
end
