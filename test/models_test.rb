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
    end

    #context "when having an identity returned" do
    #
    #  setup do
    #    @payment_identity = PaymentIdentity.new(:goid => GoPay.configuration.goid,
    #                                            :variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
    #                                            :payment_session_id => "3000531599")
    #  end
    #
    #  should "validate it" do
    #    assert @payment_identity.valid_for_signature?("c4102debd8485dea8646cc8e35b7a69d158c97c45674c680ffdbe7047a88933fd82844192ccbee46a5b661f6d58385a0")
    #  end
    #end

  end

end
