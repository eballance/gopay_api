require "savon"
require "pp"

Savon.configure { |config|  config.log = false }

module GoPay

  module Soap

    class PaymentMethod

      attr_reader :code, :offline, :payment_method, :logo

      def initialize(hash)
        @code = hash[:code]
        @offline = hash[:offline]
        @payment_method = hash[:payment_method]
        @description = hash[:description]
        @logo = hash[:logo]
      end

      def self.all
        client = Savon::Client.new "https://testgw.gopay.cz/axis/EPaymentService?wsdl"
        response = client.request("paymentMethodList")
        response.to_hash[:payment_method_list_response][:payment_method_list_return][:payment_method_list_return].map do |item|
          PaymentMethod.new(item)
        end
      end

    end

  end

end