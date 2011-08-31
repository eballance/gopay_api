require "savon"

Savon.configure { |config| config.log = false }

module GoPay

  class Payment

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value) if self.respond_to?(key)
      end
    end

    attr_reader :product_name, :total_price_in_cents, :variable_symbol, :payment_channels, :payment_channel, :session_state
    attr_accessor :payment_session_id, :last_response


    def validate_response(response, status)
      goid = (response[:eshop_go_id].to_s == GoPay.configuration.goid.to_s) || (response[:buyer_go_id].to_s == GoPay.configuration.goid.to_s)
      {:result => GoPay::CALL_COMPLETED,
       :result_description => status,
       :variable_symbol => variable_symbol,
       :product_name => product_name,
       :total_price => total_price_in_cents.to_s
      }.all? { |key, value| response[key].to_s == value.to_s } && goid
    end

    def valid?(response, status = nil)
      if status
        validate_response(response, status) && validate_signature_with_status(response)
      else
        validate_response(response, GoPay::WAITING) && validate_signature(response)
      end
    end

    def validate_signature(response)
      GoPay::Crypt.sha1(self.concat_for_validation) == GoPay::Crypt.decrypt(response[:encrypted_signature])
    end

    def validate_signature_with_status(response)
      GoPay::Crypt.sha1(self.concat_for_validation_with_status) == GoPay::Crypt.decrypt(response[:encrypted_signature])
    end

    def concat_for_create
      [GoPay.configuration.goid.to_s,
       product_name.strip,
       total_price_in_cents.to_s,
       variable_symbol.strip,
       GoPay.configuration.failed_url,
       GoPay.configuration.success_url,
       GoPay.configuration.secret].map { |attr| attr.to_s }.join("|")
    end

    def concat_for_check
      [GoPay.configuration.goid.to_s,
       payment_session_id.to_s,
       GoPay.configuration.secret].map { |attr| attr.to_s.strip }.join("|")
    end

    def concat_for_validation
      [GoPay.configuration.goid.to_s,
       last_response[:product_name],
       last_response[:total_price],
       last_response[:variable_symbol],
       last_response[:result],
       last_response[:session_state],
       GoPay.configuration.secret].map { |attr| attr.to_s.strip }.join("|")
    end

    def concat_for_validation_with_status
      repaired_payment_channel = last_response[:payment_channel].is_a?(Hash) ? "" : last_response[:payment_channel]
      [GoPay.configuration.goid.to_s,
       last_response[:product_name],
       last_response[:total_price],
       last_response[:variable_symbol],
       last_response[:result],
       last_response[:session_state],
       repaired_payment_channel,
       GoPay.configuration.secret].map { |attr| attr.to_s.strip }.join("|")
    end

    def gopay_url
      return unless payment_session_id
      parameters = {"sessionInfo.eshopGoId" => GoPay.configuration.goid,
                    "sessionInfo.paymentSessionId" => payment_session_id,
                    "sessionInfo.encryptedSignature" => GoPay::Crypt.encrypt(self.concat_for_check),
                    "paymentChannel" => "cz_gp_w"}
      query_string = parameters.map { |key, value| "#{key}=#{value}" }.join("&")
      GoPay.configuration.urls["full_integration"] + "?" + query_string
    end

  end

end
