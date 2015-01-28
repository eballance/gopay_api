require "gopay/config"
require "gopay/crypt"

require "gopay/models/payment_method"
require "gopay/models/base_payment"

require "gopay/railtie" if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3

module GoPay
  class CallNotCompletedError < StandardError; end
  class InvalidIdentityError < StandardError; end
end