source "http://rubygems.org"

# Specify your gem's dependencies in artoo.gemspec
gemspec

# For the front end web application
gem 'sass'
gem 'coffee-script'
gem 'sprockets'
gem 'compass'
gem 'bootstrap-sass'
gem 'guard'
gem 'guard-sprockets'
gem 'guard-compass'
gem 'rb-inotify', '~> 0.8.8'
gem 'execjs'

# For documentation
gem 'yard'
gem 'yard-sinatra'
gem 'kramdown'

# For tests
gem "minitest", "~> 5.0.1"
gem "minitest-happy"
gem "mocha", '~> 0.14.0', :require => false

gem 'json', '~> 1.7.7'
gem "foreman"

platforms :jruby do
  gem 'therubyrhino'
end

platforms :ruby do
  gem 'therubyracer'
end
