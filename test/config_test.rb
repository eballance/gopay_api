require "test_helper"

class ConfigTest < Test::Unit::TestCase

  context "GoPay configured" do

    GoPay.configure do |config|
      config.environment = :test
      config.goid = "8531903182"
    end

    should "load both config and country_codes yml files" do
      assert_equal "Česká Republika", GoPay.configuration.country_codes["CZE"]
      assert_equal "https://testgw.gopay.cz/zaplatit-plna-integrace", GoPay.configuration.urls["full_integration_url"]
      assert_equal "8531903182", GoPay.configuration.goid
    end

  end

end
