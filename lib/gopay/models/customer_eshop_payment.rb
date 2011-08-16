module GoPay

  class CustomerEshopPayment < Payment

    attr_reader :first_name, :last_name, :city, :street, :postal_code, :country_code, :email, :phone_number

    def create
      client = Savon::Client.new GoPay.configuration.urls["wsdl"]
      response = client.request "createCustomerPaymentSession" do |soap|
        soap.body = {"paymentCommand" => self.to_soap}
      end
      response = response.to_hash[:create_customer_payment_session_response][:create_customer_payment_session_return]
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
       "paymentChannels" => (payment_channels || []).join(","),
       "customerData" => {
           "firstName" => first_name,
           "lastName" => last_name,
           "city" => city,
           "street" => street,
           "postalCode" => postal_code,
           "countryCode" => country_code,
           "email" => email,
           "phoneNumber" => phone_number}
      }
    end

  end

end
