require 'artoo/base'
require 'artoo/delegator'

module Artoo
  # Execution context for top-level robots
  # DSL methods executed on main are delegated to this class like Sinatra
  class MainRobot < Artoo::Robot

    # we assume that the first file that requires 'artoo' is the
    # app_file. all other path related options are calculated based
    # on this path by default.
    set :app_file, caller_files.first || $0
    set :start_work, Proc.new { File.expand_path($0) == File.expand_path(app_file) }

    # if run? && ARGV.any?
    #   require 'optparse'
    #   OptionParser.new { |op|
    #     op.on('-p port',   'set the port (default is 4567)')                { |val| set :port, Integer(val) }
    #     op.on('-o addr',   'set the host (default is 0.0.0.0)')             { |val| set :bind, val }
    #     op.on('-e env',    'set the environment (default is development)')  { |val| set :environment, val.to_sym }
    #     op.on('-s server', 'specify rack server/handler (default is thin)') { |val| set :server, val }
    #     op.on('-x',        'turn on the mutex lock (default is off)')       {       set :lock, true }
    #   }.parse!(ARGV.dup)
    # end
  end

  at_exit { MainRobot.work! if $!.nil? && MainRobot.start_work? }
end

# include would include the module in Object
# extend only extends the `main` object
extend Artoo::Delegator
