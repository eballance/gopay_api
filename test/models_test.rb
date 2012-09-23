require "test_helper"

class ModelsTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load payment methods" do
      assert GoPay::PaymentMethod.all.first.is_a?(GoPay::PaymentMethod)
    end

    context "when having test BasePayment" do
      setup do
        @base_payment = GoPay::BasePayment.new(:order_number => 'xxxxyyyy',
                                               :product_name => "productName",
                                               :total_price_in_cents => 10000,
                                               :default_payment_channel => "cz_vb",
                                               :currency => 'CZK',
                                               :payment_channels => ["cz_ge", "cz_vb", "cz_sms"],
                                               :email => 'patrikjira@gmail.com')
      end

      should "create and verify this payment on paygate" do
        assert @base_payment.create
        assert @base_payment.payment_session_id.to_i > 0
        assert @base_payment.response.is_a?(Hash)
      end

      should "load payment, verify it and check status" do
        @base_payment.create
        assert @base_payment.load
        assert @base_payment.is_in_status?(GoPay::STATUSES[:created])
      end

    end

    context "when having test BasePayment with stubbed credentials" do
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


      should "validate base payment identity" do
        params = {'targetGoId' => GoPay.configuration.goid.to_s,
                  'orderNumber' => 'xxxxyyyy',
                  'paymentSessionId' => '123456',
                  'encryptedSignature' => 'e8557aba66dde7923f7ae4594fde08b4812ed5d2a5b9ed6b66a372e8d3c41f0b91da996af1fe7fad'}

        assert @base_payment.valid_identity?(params, true)
      end

    end

  end

end
