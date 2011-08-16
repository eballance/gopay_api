module GoPay

  class BuyerPayment < EshopPayment

    def to_soap
      hash = super
      hash.delete("eshopGoId")
      hash.merge!("buyerGoId" => GoPay.configuration.goid.to_i)
    end

  end

end
