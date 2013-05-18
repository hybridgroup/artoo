require 'bundler'
Bundler::GemHelper.install_tasks
require 'pry'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task :default => :test

desc "Start an interactive session with robot(s) loaded."
task :console, :file do |t, args|
  robot_file = args[:file]
  exec "bundle exec robi #{robot_file}"
end

