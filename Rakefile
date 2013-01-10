require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end

task :default => :test


# task :test do
#   ruby "test/artoo_test.rb test/delegator_test.rb"
# end