# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "http_link_header/version"

Gem::Specification.new do |s|
  s.name        = "http_link_header"
  s.version     = HttpLinkHeader::VERSION
  s.authors     = ["Clyde Law"]
  s.email       = ["claw@alum.mit.edu"]
  s.homepage    = %q{http://github.com/Umofomia/http_link_header}
  s.summary     = %q{Parses and generates HTTP Link headers as defined by IETF RFC 5988.}
  s.description = %q{Parses and generates HTTP Link headers as defined by IETF RFC 5988.}
  s.license     = 'MIT'

  s.rubyforge_project = "http_link_header"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
