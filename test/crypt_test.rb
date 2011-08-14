require "test_helper"

class CryptTest < Test::Unit::TestCase

  context "GoPay configured" do

    setup do
      @payment_command = GoPay::PaymentCommand.new({:variable_symbol => "gopay_test_#{GoPay.configuration.goid}",
                                                    :total_price_in_cents => 100,
                                                    :product_name => "productName"})
    end

    should "generate sha1 hexdigest for an object" do
      assert_equal "aa31aa6c949ca1914f3cf7f6b3cfbd837881f249",
                   GoPay::Crypt.sha1(@payment_command.concat)
    end

    should "generate encrypted signature for an object" do
      assert_equal "0cb8bc2479744ffab52b828df43bf27cd0e73c2b128c21863ff39585a98d2195c49fdee291ec44df",
                   GoPay::Crypt.encrypt(@payment_command)
    end

    should "decrypt self encrypted signature" do
      encrypted_stuff = GoPay::Crypt.encrypt(@payment_command)
      assert_equal GoPay::Crypt.sha1(@payment_command.concat), GoPay::Crypt.decrypt(encrypted_stuff)
    end

  end

end
