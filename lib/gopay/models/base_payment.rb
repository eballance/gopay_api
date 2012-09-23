require "savon"

Savon.configure { |config| config.log = false }

module GoPay

  class BasePayment

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value) if self.respond_to?(key)
      end
      @target_goid ||= GoPay.configuration.goid.to_s
      @secure_key ||= GoPay.configuration.secure_key.to_s
      @payment_channels ||= []
      @payment_channels = @payment_channels.join(',')
    end

    attr_reader :target_goid, :product_name, :total_price_in_cents, :currency,
                :order_number, :payment_channels, :default_payment_channel, :secure_key,
                :first_name, :last_name, :city, :street, :postal_code, :country_code,
                :email, :phone_number, :p1, :p2, :p3, :p4, :lang,
                :session_state
    attr_accessor :payment_session_id, :last_response

    def create
      client = Savon::Client.new GoPay.configuration.urls["wsdl"]
      response = client.request "createPayment" do |soap|
        soap.body = {"paymentCommand" => self.to_soap}
      end
      response = response.to_hash[:create_payment_response][:create_payment_return]
      self.payment_session_id = response[:payment_session_id]
      self.last_response = response
      valid_response?(response, GoPay::CREATED)
    end

    def to_soap
      {"targetGoId" => target_goid.to_i,
       "productName" => product_name,
       "totalPrice" => total_price_in_cents,
       "currency" => currency,
       "orderNumber" => order_number,
       "successURL" => GoPay.configuration.success_url,
       "failedURL" => GoPay.configuration.failed_url,
       "preAuthorization" => false,
       "defaultPaymentChannel" => default_payment_channel,
       "recurrentPayment" => false,
       "encryptedSignature" => GoPay::Crypt.encrypt(self.concat_payment_command),
       "customerData" => {
           "firstName" => first_name,
           "lastName" => last_name,
           "city" => city,
           "street" => street,
           "postalCode" => postal_code,
           "countryCode" => country_code,
           "email" => email,
           "phoneNumber" => phone_number},
       "paymentChannels" => payment_channels,
       "lang" => lang}
    end

    def to_check_soap
      {"eshopGoId" => GoPay.configuration.goid.to_i,
       "paymentSessionId" => payment_session_id,
       "encryptedSignature" => GoPay::Crypt.encrypt(self.concat_for_check)}
    end

    def valid_response?(response, status)
      goid_valid = (response[:target_go_id].to_s == target_goid)

      response_valid = {:result => GoPay::CALL_COMPLETED,
                        :session_state => status,
                        :product_name => product_name,
                        :total_price => total_price_in_cents.to_s
      }.all? { |key, value| response[key].to_s == value.to_s }

      response_valid && goid_valid
    end

    def valid_identity?(params)
      params['targetGoId'] == target_goid.to_s &&
          params['orderNumber'] == order_number.to_s &&
          GoPay::Crypt.sha1(concat_payment_identity(params)) == GoPay::Crypt.decrypt(params['encryptedSignature'])
    end

    def concat_payment_identity(params)
      [params['targetGoId'],
       params['paymentSessionId'],
       params['parentPaymentSessionId'],
       params['orderNumber'],
       secure_key].map { |attr| attr.to_s.strip }.join("|")
    end

    def concat_payment_command
      [target_goid,
       product_name.strip,
       total_price_in_cents,
       currency,
       order_number,
       GoPay.configuration.failed_url,
       GoPay.configuration.success_url,
       0, #preAuthorization
       0, #recurrentPayment
       nil, #recurrenceDateTo
       nil, #recurrenceCycle
       nil, #recurrencePeriod,
       payment_channels,
       secure_key].map { |attr| attr.to_s }.join("|")
    end

    def concat_payment_session
      [target_goid,
       payment_session_id,
       secure_key].map { |attr| attr.to_s.strip }.join("|")
    end

    def gopay_url
      return unless payment_session_id
      parameters = {"sessionInfo.targetGoId" => target_goid,
                    "sessionInfo.paymentSessionId" => payment_session_id,
                    "sessionInfo.encryptedSignature" => GoPay::Crypt.encrypt(self.concat_payment_session)}
      query_string = parameters.map { |key, value| "#{key}=#{value}" }.join("&")
      GoPay.configuration.urls["full_integration"] + "?" + query_string
    end

  end

end
