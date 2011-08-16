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
                                            :product_name => "productName"})
      end

      should "create and verify this payment on paygate" do
        created = @payment.create
        assert created.is_a?(GoPay::EshopPayment)
        assert created.payment_session_id.to_i > 0
        assert created.last_response.is_a?(Hash)
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
                                                    :phone_number => "777 777 777"})
      end

      should "create and verify this payment on paygate" do
        created = @payment.create
        assert created.is_a?(GoPay::CustomerEshopPayment)
        assert created.payment_session_id.to_i > 0
        assert created.last_response.is_a?(Hash)
      end
    end
  end

end
