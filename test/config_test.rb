# encoding: utf-8
require "test_helper"

class ConfigTest < Minitest::Test
  context "GoPay configured" do
    should "load config yml file" do
      assert_equal "https://testgw.gopay.cz/gw/pay-full-v2", GoPay.configuration.urls["full_integration"]
    end
  end
end
