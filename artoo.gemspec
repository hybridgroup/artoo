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
end
