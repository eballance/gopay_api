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
                                                :payment_session_id => 1)
      end

      should "validate it" do
        assert @payment_identity.valid_for_signature?("718337e3e4e721dd4ab6684750071fc035bd3f573abfb33046f583e56a4671a674843441558bd515")
      end
    end

  end

end
