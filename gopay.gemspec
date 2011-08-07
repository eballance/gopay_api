# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lib/gopay/version"

Gem::Specification.new do |s|
  s.name        = "gopay"
  s.version     = GoPay::VERSION
  s.authors     = ["papricek"]
  s.email       = ["patrikjira@gmail.com"]
  s.homepage    = ""
  s.summary     = "A little gem making integration of GoPay easy"
  s.description = "A little gem making integration of GoPay easy"

  s.rubyforge_project = "gopay"

  s.add_development_dependency "rspec"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
end
