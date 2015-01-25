$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'minitest/autorun'
require "shoulda"

if RUBY_VERSION > "1.9"
  require 'mocha/setup'
else
  require 'mocha'
end

require "gopay"
require "awesome_print"

GoPay.configure do |config|
  config.environment = :test
end

# create your own test.yml (see test.example.yml)
GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "test.yml"))

HTTPI.log = false # silences warning like HTTPI executes HTTP POST using the net_http adapter
