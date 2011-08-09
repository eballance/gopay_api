require "test_helper"

class SoapTest < Test::Unit::TestCase

  context "GoPay configured" do

    setup do
      GoPay::Config.init("test")
    end

    should "load payment methods" do
      assert GoPay::Soap::PaymentMethod.all.first.is_a?(GoPay::Soap::PaymentMethod)
    end

  end

end
