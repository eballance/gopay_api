$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'test/unit'
require "shoulda"
require "gopay"

GoPay.configure do |config|
  config.environment = :test
  config.goid = "8531903182"
  config.success_url = "http://example.com/success"
  config.failed_url = "http://example.com/failed"
  config.secret = "a7ksDBye2Pm9sEwx3PfLiV6E"
end

GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "test_config.yml"))
