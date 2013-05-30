# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gopay/version"

Gem::Specification.new do |s|
  s.name = "gopay"
  s.version = GoPay::VERSION
  s.authors = ["papricek"]
  s.email = ["patrikjira@gmail.com"]
  s.homepage = "http://gopay.defactory.net"
  s.summary = "A little gem making integration of GoPay easy"
  s.description = "GoPay is a library making it easy to access GoPay http://www.gopay.cz paygate from Ruby. It offers some basic wrapper around soap calls in the form of AR-like models. Its autoconfigurable from Rails."

  s.rubyforge_project = "gopay"

  s.add_dependency("savon",  ">= 2.0.0")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("mocha")

  s.files = `git ls-files`.split("\n")

  s.test_files = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]
end
