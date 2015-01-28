require "savon"

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

    attr_accessor :payment_session_id, :response

    def create
      client = Savon::Client.new wsdl: GoPay.configuration.urls["wsdl"], log: false
      soap_response = client.call :create_payment, message: { payment_command: payment_command_hash }

      self.response = soap_response.to_hash[:create_payment_response][:create_payment_return]
      valid = valid_response?(response, GoPay::STATUSES[:created])
      self.payment_session_id = response[:payment_session_id] if valid
      valid
    end

    def load(validated_status = nil)
      client = Savon::Client.new wsdl: GoPay.configuration.urls["wsdl"], log: false
      soap_response = client.call :payment_status, message: { payment_session_info: payment_session_hash }

      self.response = soap_response.to_hash[:payment_status_response][:payment_status_return]
      valid_payment_session?(response, validated_status)
    end

    def is_in_status?(status)
      load(status)
    end

    def payment_command_hash
      {
        "targetGoId"  => target_goid.to_i,
        "productName" => product_name,
        "totalPrice"  => total_price_in_cents,
        "currency"    => currency,
        "orderNumber" => order_number,
        "successURL"  => GoPay.configuration.success_url,
        "failedURL"   => GoPay.configuration.failed_url,
        "preAuthorization"      => false,
        "defaultPaymentChannel" => default_payment_channel,
        "recurrentPayment"      => false,
        "encryptedSignature"    => GoPay::Crypt.encrypt(concat_payment_command),
        "customerData" => {
          "firstName" => first_name,
          "lastName"  => last_name,
          "city"      => city,
          "street"    => street,
          "postalCode"  => postal_code,
          "countryCode" => country_code,
          "email"       => email,
          "phoneNumber" => phone_number},
        "paymentChannels" => payment_channels,
        "lang" => lang
      }
    end

    def payment_session_hash
      {
        "targetGoId"         => target_goid.to_i,
        "paymentSessionId"   => payment_session_id,
        "encryptedSignature" => GoPay::Crypt.encrypt(concat_payment_session)
      }
    end

    def valid_response?(response, status)
      raise "CALL NOT COMPLETED " if response[:result] != GoPay::STATUSES[:call_completed]
      goid_valid = (response[:target_go_id].to_s == target_goid)

      response_valid = {
        session_state: status,
        product_name:  product_name,
        total_price:   total_price_in_cents.to_s
      }.all? { |key, value| response[key].to_s == value.to_s }

      response_valid && goid_valid
    end

    def valid_payment_session?(response, status = nil)
      raise "CALL NOT COMPLETED " if response[:result] != GoPay::STATUSES[:call_completed]
      
      status_valid = if status
                       response[:session_state] == status
                     else
                       GoPay::STATUSES.values.include?(response[:session_state])
                     end
      response_valid = {
        order_number: order_number,
        product_name: product_name,
        target_go_id: target_goid,
        total_price:  total_price_in_cents,
        currency:     currency
      }.all? { |key, value| response[key].to_s == value.to_s }

      signature_valid = GoPay::Crypt.sha1(concat_payment_status(response)) == GoPay::Crypt.decrypt(response[:encrypted_signature])
      status_valid && response_valid && signature_valid
    end

    def valid_identity?(params, padding_off = false)
      raise 'invalid targetGoId'         unless params['targetGoId'] == target_goid.to_s
      raise 'invalid orderNumber'        unless params['orderNumber'] == order_number.to_s
      raise 'invalid encryptedSignature' unless GoPay::Crypt.sha1(concat_payment_identity(params)) == GoPay::Crypt.decrypt(params['encryptedSignature'], padding_off)
      true
    end

    def concat_payment_identity(params)
      [
        params['targetGoId'],
        params['paymentSessionId'],
        params['parentPaymentSessionId'],
        params['orderNumber'],
        secure_key
      ].map { |attr| attr.to_s.strip }.join("|")
    end

    def concat_payment_command
      [
        target_goid,
        product_name.strip,
        total_price_in_cents,
        currency,
        order_number,
        GoPay.configuration.failed_url,
        GoPay.configuration.success_url,
        0,   # preAuthorization
        0,   # recurrentPayment
        nil, # recurrenceDateTo
        nil, # recurrenceCycle
        nil, # recurrencePeriod,
        payment_channels,
        secure_key
      ].map { |attr| attr.to_s }.join("|")
    end

    def concat_payment_session
      [target_goid, payment_session_id, secure_key].map { |attr| attr.to_s.strip }.join("|")
    end

    def concat_payment_status(response)
      [
        response[:target_go_id],
        response[:product_name],
        response[:total_price],
        response[:currency],
        response[:order_number],
        response[:recurrent_payment] ? 1 : 0,
        response[:parent_payment_session_id],
        response[:pre_authorization] ? 1 : 0,
        response[:result],
        response[:session_state],
        response[:session_sub_state],
        response[:payment_channel],
        secure_key
      ].map { |attr| attr.is_a?(Hash) ? "" : attr.to_s }.join("|")
    end

    def gopay_url
      return unless payment_session_id
      parameters = {
        "sessionInfo.targetGoId"         => target_goid,
        "sessionInfo.paymentSessionId"   => payment_session_id,
        "sessionInfo.encryptedSignature" => GoPay::Crypt.encrypt(self.concat_payment_session)
      }
      query_string = parameters.map { |key, value| "#{key}=#{value}"}.join("&")
      GoPay.configuration.urls["full_integration"] + "?" + query_string
    end
  end
end
