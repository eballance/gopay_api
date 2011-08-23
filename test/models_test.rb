require "test_helper"

class ModelsTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load payment methods" do
      assert GoPay::PaymentMethod.all.first.is_a?(GoPay::PaymentMethod)
    end

    context "when having test EshopPayment" do
      setup do
        @payment = GoPay::EshopPayment.new({:variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
                                            :total_price_in_cents => 100,
                                            :product_name => "productName",
                                            :payment_channels => ["cz_gp_w"]})
      end

      should "create and verify this payment on paygate" do
        created = @payment.create
        assert created.is_a?(GoPay::EshopPayment)
        assert created.payment_session_id.to_i > 0
        assert created.last_response.is_a?(Hash)
      end

      should "check status of that payment" do
        created = @payment.create
        @payment.is_in_state?(GoPay::WAITING)
      end
    end

    context "when having test CustomerEshopPayment" do
      setup do
        @payment = GoPay::CustomerEshopPayment.new({:variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
                                                    :total_price_in_cents => 100,
                                                    :product_name => "productName",
                                                    :first_name => "Patrik",
                                                    :last_name => "Jira",
                                                    :city => "Praha",
                                                    :street => "Prazska",
                                                    :country_code => "420",
                                                    :postal_code => "140 00",
                                                    :email => "patrikjira@example.com",
                                                    :phone_number => "777 777 777",
                                                    :payment_channel => "cz_gp_w"})
      end

      should "create and verify this payment on paygate" do
        created = @payment.create
        assert created.is_a?(GoPay::CustomerEshopPayment)
        assert created.payment_session_id.to_i > 0
        assert created.last_response.is_a?(Hash)
      end
    end

    context "when having test BuyerPayment" do
      setup do
        stub_buyer_credentials!
        @payment = GoPay::BuyerPayment.new({:variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
                                            :total_price_in_cents => 100,
                                            :product_name => "productName",
                                            :payment_channel => "cz_gp_w"
                                           })
      end

      should "create and verify this payment on paygate" do
        created = @payment.create
        assert created.is_a?(GoPay::BuyerPayment)
        assert created.payment_session_id.to_i > 0
        assert created.last_response.is_a?(Hash)
      end

      should "check status of that payment" do
        @payment.create
        @payment.is_in_state?(GoPay::WAITING)
      end

    end

    context "when having an identity returned" do

      setup do
        @payment_identity = PaymentIdentity.new(:goid => GoPay.configuration.goid,
                                                :variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
                                                :payment_session_id => "3000531599")
      end

      should "validate it" do
        assert @payment_identity.valid_for_signature?("c4102debd8485dea8646cc8e35b7a69d158c97c45674c680ffdbe7047a88933fd82844192ccbee46a5b661f6d58385a0")
      end
    end

  end

end
