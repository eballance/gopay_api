$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'test/unit'
require "shoulda"

require "gopay"

class ConfigTest < Test::Unit::TestCase

  should "load both config and country_codes yml files" do
    config = GoPay::Config.new("test")
    assert_equal "Česká Republika", config.country_codes["CZE"]
    assert_equal "https://testgw.gopay.cz/zaplatit-plna-integrace", config.urls["full_integration_url"]
  end

end
