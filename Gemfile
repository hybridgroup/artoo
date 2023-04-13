source "http://rubygems.org"

# Specify your gem's dependencies in artoo.gemspec
gemspec

# For documentation
gem 'yard'
gem 'yard-sinatra'
gem 'kramdown'

# For tests
gem "minitest", "~> 5.0.1"
gem "minitest-happy"
gem "mocha", '~> 0.14.0', :require => false

gem 'json'
gem "foreman"

platforms :jruby do
  gem 'therubyrhino'
end

platforms :ruby do
  gem 'therubyracer'
end
