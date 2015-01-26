require "test_helper"

class CryptTest < Minitest::Test
  context "GoPay configured" do
    setup do
      GoPay.configuration.stubs(:goid).returns('1234567890')
      GoPay.configuration.stubs(:secure_key).returns('405ed9cacf63d5b123d65d09')
      @base_payment = GoPay::BasePayment.new(order_number: 'xxxxyyyy',
                                             product_name: "productName",
                                             total_price_in_cents:    10000,
                                             default_payment_channel: "cz_vb",
                                             currency:         'CZK',
                                             payment_channels: ["cz_ge", "cz_vb", "cz_sms"],
                                             email:            'patrikjira@gmail.com')
    end

    should "generate sha1 hexdigest for an object" do
      assert_equal "28385c4286c7235d6baca5f6dce963500cc3531e",
                   GoPay::Crypt.sha1(@base_payment.concat_payment_command)
    end

    should "generate encrypted signature for an object" do
      assert_equal "c7c41e5e1bcc5b22abb297b2b0de523689d35fa444fda0cc83eee8616e78aaa4f3eb16f8326a2c74",
                   GoPay::Crypt.encrypt(@base_payment.concat_payment_command)
    end
  end
end
