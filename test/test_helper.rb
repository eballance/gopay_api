$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'test/unit'
require "shoulda"
require 'mocha'

require "gopay"
require "awesome_print"

GoPay.configure do |config|
  config.environment = :test
end

# create your own test.yml (see test.example.yml)
GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "test.yml"))
