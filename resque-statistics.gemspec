# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "resque-statistics"

Gem::Specification.new do |s|
  s.name        = "resque-statistics"
  s.version     = Resque::Plugins::Statistics::VERSION
  s.authors     = ["Benjamin Krause"]
  s.email       = ["bk@benjaminkrause.com"]
  s.homepage    = ""
  s.summary     = %q{Resque Statistics Extension}
  s.description = %q{Gather various statistics about job execution}

  s.rubyforge_project = "resque-statistics"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rspec', '2.6.0'
  s.add_development_dependency 'delorean', '~> 1.0.1'
  s.add_dependency 'resque-meta', '~> 1.0.3'
end
