require "gopay/config"

module GoPay

  class Base

    attr_accessor :environment
    attr_reader :config
    
    def initialize(environment = :production)
      @environment = environment
      @config = GoPay::Config.new(environment)
    end

  end

end
