require "test_helper"

class ConfigTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load both config and country_codes yml files" do
      assert_equal "Česká Republika", GoPay.configuration.country_codes["CZE"]
      assert_equal "https://testgw.gopay.cz/zaplatit-plna-integrace", GoPay.configuration.urls["full_integration"]
      assert_equal 8531903182, GoPay.configuration.goid
      assert_equal "http://www.failed_url.cz", GoPay.configuration.failed_url
    end

  end

end
