require "test_helper"

class CryptTest < Test::Unit::TestCase

  context "GoPay configured" do

    setup do
      GoPay.configuration.stubs(:goid).returns('1234567890')
      GoPay.configuration.stubs(:secure_key).returns('405ed9cacf63d5b123d65d09')
      @base_payment = GoPay::BasePayment.new(:order_number => 'xxxxyyyy',
                                             :product_name => "productName",
                                             :total_price_in_cents => 10000,
                                             :default_payment_channel => "cz_vb",
                                             :currency => 'CZK',
                                             :payment_channels => ["cz_ge", "cz_vb", "cz_sms"],
                                             :email => 'patrikjira@gmail.com')
    end

    should "generate sha1 hexdigest for an object" do
      assert_equal "8dc10d197e260b55ac6aea7702246ef87435404e",
                   GoPay::Crypt.sha1(@base_payment.concat_payment_command)
    end

    should "generate encrypted signature for an object" do
      assert_equal "1fa2d2682dead62ba7bdb0f34ba304888f9cbb26df18b5a69d2cdeb73d7511b14791c68cc7eadb61",
                   GoPay::Crypt.encrypt(@base_payment.concat_payment_command)
    end

  end

end
