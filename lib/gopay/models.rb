require "savon"
require "pp"

Savon.configure { |config| config.log = false }

module GoPay

  class PaymentCommand

    attr_accessor :product_name, :total_price_in_cents, :variable_symbol

    def create
      client = Savon::Client.new GoPay.configuration.urls["wsdl"]
      params = self.to_soap
      pp params
      response = client.request "createPaymentSession" do |soap|
        soap.body = {"paymentCommand" => params}
      end
      pp response.to_hash
    end

    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set :"@#{key}", value
      end

    end

    def signature
      GoPay::Crypt.encrypt(GoPay::Crypt.sha1(self.concat), GoPay.configuration.secret)
    end

    def to_soap
      {"eshopGoId" => GoPay.configuration.goid.to_i,
       "productName" => product_name,
       "totalPrice" => total_price_in_cents,
       "variableSymbol" => variable_symbol,
       "successURL" => GoPay.configuration.success_url,
       "failedURL" => GoPay.configuration.failed_url,
       "encryptedSignature" => signature}
    end

    def concat
      [GoPay.configuration.goid, product_name.strip, total_price_in_cents, variable_symbol.strip,
       GoPay.configuration.failed_url, GoPay.configuration.success_url, GoPay.configuration.secret].map { |attr| attr }.join("|")
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