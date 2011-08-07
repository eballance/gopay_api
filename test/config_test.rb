$: << File.join(File.expand_path(File.dirname(__FILE__)), "../lib")

require "rubygems"
require 'test/unit'
require "shoulda"

require "gopay"

class ConfigTest < Test::Unit::TestCase

  subject { GoPay::Config.instance("test") }

  should "load both config and country_codes yml files" do
    assert_equal "Česká Republika", subject.country_codes["CZE"]
    assert_equal "https://testgw.gopay.cz/zaplatit-plna-integrace", subject.config["full_integration_url"]
  end

end
