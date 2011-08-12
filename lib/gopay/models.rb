require "savon"
require "pp"

Savon.configure { |config| config.log = false }

module GoPay

  module Models

    class PaymentCommand

      attr_reader :goid, :product_name, :total_price_in_cents, :variable_symbol

      def concat
        [GoPay.goid, product_name, total_price_in_cents, variable_symbol,
         GoPay.success_url, GoPay.failed_url, GoPay.secret].map { |attr| attr.strip }.join("|")
      end

    end

    class PaymentResult

      attr_reader :goid, :product_name, :total_price_in_cents, :variable_symbol, :result, :session_state

      def concat
        [GoPay.goid, product_name, total_price_in_cents, variable_symbol,
         result, session_state, GoPay.secret].map { |attr| attr.strip }.join("|")
      end

    end

    class PaymentStatus

      attr_reader :goid, :product_name, :total_price_in_cents, :variable_symbol, :result, :session_state, :payment_channel

      def concat
        [GoPay.goid, product_name, total_price_in_cents, variable_symbol,
         result, session_state, payment_channel, GoPay.secret].map { |attr| attr.strip }.join("|")
      end

    end

    class PaymentSession

      attr_reader :payment_session_id

      def concat
        [GoPay.goid, payment_session_id, GoPay.secret].map { |attr| attr.strip }.join("|")
      end

    end

    class PaymentIdentity

      attr_reader :payment_session_id, :variable_symbol

      def concat
        [GoPay.goid, payment_session_id, variable_symbol, GoPay.secret].map { |attr| attr.strip }.join("|")
      end

    end

    class Buyer

      attr_reader :buyer_user_name, :buyer_email

      def concat
        [GoPay.goid, buyer_user_name, buyer_email, GoPay.secret].map { |attr| attr.strip }.join("|")
      end

    end


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