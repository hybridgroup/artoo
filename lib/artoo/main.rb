require 'artoo/delegator'
require 'artoo/robot'

module Artoo
  # Execution context for top-level robots
  # DSL methods executed on main are delegated to this class like Sinatra
  class MainRobot < Artoo::Robot

    # We assume that the first file that requires 'artoo' is the
    # app_file. all other path related options are calculated based
    # on this path by default.
    set :app_file, caller_files.first || $0
    set :start_work, Proc.new { File.expand_path($0) == File.expand_path(app_file) }
  end

  at_exit { MainRobot.work! if $!.nil? && MainRobot.start_work? }
end

# include would include the module in Object,
# extend only extends the `main` object
extend Artoo::Delegator
