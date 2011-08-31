module GoPay

  class EshopPayment < Payment

    def create
      client = Savon::Client.new GoPay.configuration.urls["wsdl"]
      response = client.request "createPaymentSession" do |soap|
        soap.body = {"paymentCommand" => self.to_soap}
      end
      response = response.to_hash[:create_payment_session_response][:create_payment_session_return]
      self.payment_session_id = response[:payment_session_id]
      self.last_response = response
      valid?(response) ? self : false
    end

    def to_soap
      {"eshopGoId" => GoPay.configuration.goid.to_i,
       "productName" => product_name,
       "totalPrice" => total_price_in_cents,
       "variableSymbol" => variable_symbol,
       "successURL" => GoPay.configuration.success_url,
       "failedURL" => GoPay.configuration.failed_url,
       "encryptedSignature" => GoPay::Crypt.encrypt(self.concat_for_create),
       "paymentChannels" => (payment_channels || []).join(",")}
    end

    def to_check_soap
      {"eshopGoId" => GoPay.configuration.goid.to_i,
       "paymentSessionId" => payment_session_id,
       "encryptedSignature" => GoPay::Crypt.encrypt(self.concat_for_check)}
    end

    def is_in_state?(desired_status)
      desired_status == actual.last_response[:session_state]
    end

    def actual
      client = Savon::Client.new GoPay.configuration.urls["wsdl"]
      response = client.request "paymentStatusGW2" do |soap|
        soap.body = {"paymentSessionInfo" => self.to_check_soap}
      end
      response = response.to_hash[:payment_status_gw2_response][:payment_status_gw2_return]
      self.last_response = response
      valid?(response, response[:result_description]) ? self : false
    end

    def actual_session_state
      actual.last_response[:session_state] || GoPay::UNKNOWN
    end

  end

end
