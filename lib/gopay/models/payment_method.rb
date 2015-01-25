require "savon"

module GoPay
  class PaymentMethod
    attr_reader :code, :offline, :payment_method, :logo

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value) if self.respond_to?(key)
      end
    end

    def self.all
      client = Savon::Client.new wsdl: GoPay.configuration.urls["wsdl"], log: false
      response = client.call :payment_method_list

      response.to_hash[:payment_method_list_response][:payment_method_list_return][:payment_method_list_return].map do |item|
        PaymentMethod.new(item)
      end
    end
  end
end
