require "test_helper"

class SoapTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load payment methods" do
      assert GoPay::Soap::PaymentMethod.all.first.is_a?(GoPay::Soap::PaymentMethod)

    end

  end

end
