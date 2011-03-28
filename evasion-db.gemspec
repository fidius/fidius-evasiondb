# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "evasion-db/version"

Gem::Specification.new do |s|
  s.name        = "fidius-evasiondb"
  s.version     = Evasion::Db::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jens Färber, Bernhard Katzmarski"]
  s.email       = ["jfaerber@tzi.de, bkatzm@tzi.de"]
  s.homepage    = "http://www.fidius.me"
  s.add_dependency('fidius-common')
  s.summary     = %q{summary here}
  s.description = %q{description here}

  s.rubyforge_project = "evasion-db"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
