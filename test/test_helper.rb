$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'test/unit'
require "shoulda"
require 'mocha'

require "gopay"
require "pp"

GoPay.configure do |config|
  config.environment = :test
end

GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "eshop_test_config.yml"))

class Test::Unit::TestCase

  def stub_buyer_credentials!
    yaml = YAML.load_file(File.join(File.dirname(__FILE__), "buyer_test_config.yml"))
    GoPay.configuration.stubs(:goid).returns(yaml["goid"].to_i)
    GoPay.configuration.stubs(:secret).returns(yaml["secret"])
  end

end
