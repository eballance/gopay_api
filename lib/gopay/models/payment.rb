require "savon"
require "pp"

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
        validate_response(response, status) && validate_signature_with_status(response, status)
      else
        validate_response(response, GoPay::WAITING) && validate_signature(response, GoPay::WAITING)
      end
    end

    def validate_signature(response, status)
      GoPay::Crypt.sha1(self.concat_for_validation(status, true)) == GoPay::Crypt.decrypt(response[:encrypted_signature])
    end

    def validate_signature_with_status(response, status)
      GoPay::Crypt.sha1(self.concat_for_validation_with_status(status, true)) == GoPay::Crypt.decrypt(response[:encrypted_signature])
    end

    def concat_for_create
      [GoPay.configuration.goid.to_s,
       product_name.strip,
       total_price_in_cents.to_s,
       variable_symbol.strip,
       GoPay.configuration.failed_url,
       GoPay.configuration.success_url,
       GoPay.configuration.secret].map { |attr| attr }.join("|")
    end

    def concat_for_check(from_last_response = false)
      [GoPay.configuration.goid.to_s,
       from_last_response ? last_response[:payment_session_id].to_s : payment_session_id.to_s,
       GoPay.configuration.secret].map { |attr| attr.strip }.join("|")
    end

    def concat_for_validation(session_state = GoPay::WAITING, from_last_response = false)
      [GoPay.configuration.goid.to_s,
       from_last_response ? last_response[:product_name] : product_name,
       from_last_response ? last_response[:total_price] : total_price_in_cents.to_s,
       from_last_response ? last_response[:variable_symbol] : variable_symbol,
       from_last_response ? last_response[:result] : GoPay::CALL_COMPLETED,
       from_last_response ? last_response[:session_state] : session_state,
       GoPay.configuration.secret].map { |attr| attr.strip }.join("|")
    end

    def concat_for_validation_with_status(session_state, from_last_response = false)
      repaired_payment_channel = from_last_response ? last_response[:payment_channel] : payment_channel
      repaired_payment_channel = "" if repaired_payment_channel.is_a? Hash
      [GoPay.configuration.goid.to_s,
       from_last_response ? last_response[:product_name] : product_name,
       from_last_response ? last_response[:total_price] : total_price_in_cents.to_s,
       from_last_response ? last_response[:variable_symbol] : variable_symbol,
       from_last_response ? last_response[:result] : GoPay::CALL_COMPLETED,
       session_state,
       repaired_payment_channel,
       GoPay.configuration.secret].map { |attr| attr.strip }.join("|")
    end

  end

end
