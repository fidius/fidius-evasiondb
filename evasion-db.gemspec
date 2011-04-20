# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "evasion-db/version"

Gem::Specification.new do |s|
  s.name        = "fidius-evasiondb"
  s.version     = FIDIUS::EvasionDB::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jens Färber", "Bernhard Katzmarski"]
  s.email       = ["jfaerber+evasiondb@tzi.de", "bkatzm+evasiondb@tzi.de"]
  s.homepage    = "http://fidius.me"

  s.add_dependency('fidius-common')
  s.add_dependency('activerecord')

  s.summary     = "The FIDIUS EvasionDB Gem provides a database which contains knowledge about "+
                  "metasploit exploits and their corresponding alerts/events produced by intrusion "+
                  "detection systems (IDS)."
  s.description = s.summary + "\n\nIt includes a Metasploit plugin which supports the recording of "+
                  "thrown alerts during the execution of an exploit."

  s.rubyforge_project = ""

  s.add_dependency "activerecord", ">= 3.0.0"
  s.add_dependency "activesupport", ">= 3.0.0"
  s.add_dependency "fidius-common", "~> 0.0.4"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.rdoc_options << '--title' << s.name <<
                    '--main'  << 'README.md' << '--show-hash' <<
                    `git ls-files -- lib/*`.split("\n") <<
                    'README.md' << 'LICENSE' << 'CREDITS.md'
end
