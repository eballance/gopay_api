require "test_helper"

class CryptTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "create test payment" do
      GoPay.configure_from_yaml(File.join(File.dirname(__FILE__), "test_config.yml"))

      payment_command = GoPay::Models::PaymentCommand.new
      payment_command.variable_symbol = "gopay_test_#{GoPay.configuration.goid}"
      payment_command.total_price_in_cents = 100
      payment_command.product_name = "productName"
      payment_command.create
      assert true
    end

  end

end
