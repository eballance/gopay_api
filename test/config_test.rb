require "test_helper"

class ConfigTest < Test::Unit::TestCase

  context "GoPay configured" do

    setup do
      GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "test_config.yml"))
      GoPay.configure do |config|
        config.environment = :test
        config.goid = "853190318211"
      end
    end

    should "load both config and country_codes yml files" do
      assert_equal "Česká Republika", GoPay.configuration.country_codes["CZE"]
      assert_equal "https://testgw.gopay.cz/zaplatit-plna-integrace", GoPay.configuration.urls["full_integration"]
      assert_equal "853190318211", GoPay.configuration.goid
      assert_equal "http://example.com/gopay/success", GoPay.configuration.success_url
    end

  end

end
