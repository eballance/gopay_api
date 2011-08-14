require "test_helper"

class ModelsTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load payment methods" do
      assert GoPay::PaymentMethod.all.first.is_a?(GoPay::PaymentMethod)
    end
    context "with @payment_method" do
      setup do
        @payment_command = GoPay::PaymentCommand.new({:variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
                                                      :total_price_in_cents => 100,
                                                      :product_name => "productName"})
      end

      should "create and verify payment" do
        assert @payment_command.create
      end


    end

  end

end
