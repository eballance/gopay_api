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

    attr_reader :product_name, :total_price_in_cents, :variable_symbol
    attr_accessor :payment_session_id


    def validate_response(response, status)
      goid = response[:eshop_go_id].to_s == GoPay.configuration.goid.to_s or response[:buyer_go_id].to_s == GoPay.configuration.goid.to_s
      {:result => GoPay::CALL_COMPLETED,
       :result_description => status,
       :variable_symbol => variable_symbol,
       :product_name => product_name,
       :total_price => total_price_in_cents.to_s
      }.all? { |key, value| response[key].to_s == value.to_s } && goid
    end

    def validate_signature(response, status)
      GoPay::Crypt.sha1(self.concat_for_validation(status)) == GoPay::Crypt.decrypt(response[:encrypted_signature])
    end

    def valid?(response)
      pp validate_response(response, GoPay::WAITING)
      pp validate_signature(response, GoPay::WAITING)
      validate_response(response, GoPay::WAITING) && validate_signature(response, GoPay::WAITING)
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

    def concat_for_check
      [GoPay.configuration.goid,
       payment_session_id,
       GoPay.configuration.secret].map { |attr| attr.strip }.join("|")
    end

    def concat_for_validation(session_state = GoPay::WAITING)
      [GoPay.configuration.goid.to_s,
       product_name,
       total_price_in_cents.to_s,
       variable_symbol,
       GoPay::CALL_COMPLETED,
       session_state,
       GoPay.configuration.secret].map { |attr| attr.strip }.join("|")
    end

  end

end
