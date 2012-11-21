# encoding: utf-8
require "test_helper"

class ConfigTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load both config and country_codes yml files" do
      assert_equal "Česká Republika", GoPay.configuration.country_codes["CZE"]
      assert_equal "http://testgw.gopay.cz/gw/pay-full-v2", GoPay.configuration.urls["full_integration"]
    end

  end

end
