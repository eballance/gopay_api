require "test_helper"

class ConfigTest < Test::Unit::TestCase

  context "GoPay configured" do

    setup do
      GoPay::Config.init("test")
    end

    should "load both config and country_codes yml files" do
      assert_equal "Česká Republika", GoPay::Config.country_codes["CZE"]
      assert_equal "https://testgw.gopay.cz/zaplatit-plna-integrace", GoPay::Config.urls["full_integration_url"]
    end

  end

end
