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
        assert @base_payment.last_response.is_a?(Hash)
      end

      #should "check status of that payment" do
      #  @payment.create
      #  assert @payment.is_in_state?(GoPay::WAITING)
      #end


      should "validate base payment identity" do
        params = {'targetGoId' => GoPay.configuration.goid.to_s,
                  'orderNumber' => 'xxxxyyyy',
                  'paymentSessionId' => '123456',
                  'encryptedSignature' => '452ec56f6aad6268b1c6551011667e24e4eb2da6c8e05a310ff0716d651dd413a6aa9c8511904ae3'}

        assert @base_payment.valid_identity?(params)
      end

    end

  end

end
