# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "matic/version"

Gem::Specification.new do |s|
  s.name        = "matic"
  s.version     = Matic::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hakan Ensari"]
  s.email       = ["code@papercavalier.com"]
  s.homepage    = "http://github.com/papercavalier/matic"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "matic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("mongomatic", "~> 0.6.0")
  s.add_development_dependency("bson_ext", "~> 1.1.0")
  s.add_development_dependency("rspec", "~> 2.0.0")
end
