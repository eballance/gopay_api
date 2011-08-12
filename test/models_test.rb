require "test_helper"

class ModelsTest < Test::Unit::TestCase

  context "GoPay configured" do

    should "load payment methods" do
      assert GoPay::Models::PaymentMethod.all.first.is_a?(GoPay::Models::PaymentMethod)

    end

  end

end
