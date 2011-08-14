$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'test/unit'
require "shoulda"
require "gopay"
require "pp"

GoPay.configure do |config|
  config.environment = :test
end

GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "test_config.yml"))
