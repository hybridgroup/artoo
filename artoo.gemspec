# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "artoo/version"

Gem::Specification.new do |s|
  s.name        = "artoo"
  s.version     = Artoo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ron Evans", "Adrian Zankich", "Ari Lerner", "Mario Ricalde", "Daniel Fischer"]
  s.email       = ["artoo@hybridgroup.com"]
  s.homepage    = "https://github.com/hybridgroup/artoo"
  s.summary     = %q{Ruby-based microframework for robotics}
  s.description = %q{Ruby-based microframework for robotics}

  s.rubyforge_project = "artoo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'celluloid', '~> 0.14.pre'
  s.add_runtime_dependency 'celluloid-io', '~> 0.14.pre'
  s.add_runtime_dependency 'reel', '~> 0.4.pre'
  s.add_runtime_dependency 'multi_json', '~> 1.6'
  s.add_runtime_dependency 'active_support', '~> 3.0'
  s.add_runtime_dependency 'rake', '~> 10.0'
  s.add_runtime_dependency 'pry', '~> 0.9'
  s.add_development_dependency 'minitest', '~> 4.6'
  s.add_development_dependency 'mocha', '~> 0.13'
end
