require "gopay/config"

module GoPay

  module Base

    attr_accessor :environment
    attr_reader :config

    @environment = "test"
    @config = GoPay::Config.new(@environment)

    def environment=(environment = :test)
      @environment = environment
      @config = GoPay::Config.new(environment)
    end

  end

end
