class PaymentIdentity

  attr_accessor :goid, :payment_session_id, :variable_symbol

  def initialize(attributes = {})
    attributes.each do |key, value|
      instance_variable_set(:"@#{key}", value) if self.respond_to?(key)
    end
  end

  def concat
    [goid.to_s,
     payment_session_id.to_s,
     variable_symbol.to_s,
     GoPay.configuration.secret].map { |attr| attr.strip }.join("|")
  end

  def valid_for_signature?(signature)
    GoPay::Crypt.sha1(self.concat) == GoPay::Crypt.decrypt(signature)
  end

end
