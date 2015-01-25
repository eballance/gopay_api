require "yaml"

module GoPay
  BASE_PATH = File.expand_path("../../../", __FILE__)
  STATUSES = {
    created:    "CREATED", 
    payment_method_chosen: "PAYMENT_METHOD_CHOSEN",
    paid:       "PAID", 
    authorized: "AUTHORIZED",
    canceled:   "CANCELED", 
    timeouted:  "TIMEOUTED",
    refunded:   "REFUNDED", 
    failed:     "FAILED",
    call_completed: "CALL_COMPLETED", 
    call_failed:    "CALL_FAILED",
    unknown:        "UNKNOWN"
  }

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure_from_yaml(path)
    yaml = YAML.load_file(path)
    return unless yaml
    
    configuration.goid        = yaml["goid"]
    configuration.success_url = yaml["success_url"]
    configuration.failed_url  = yaml["failed_url"]
    configuration.secure_key  = yaml["secure_key"]
    
    configuration
  end

  def self.configure_from_rails
    path = ::Rails.root.join("config", "gopay.yml")
    configure_from_yaml(path) if File.exists?(path)
    
    env = if defined?(::Rails) && ::Rails.respond_to?(:env)
            ::Rails.env.to_sym
          elsif defined?(::RAILS_ENV)
            ::RAILS_ENV.to_sym
          end
    configuration.environment ||= (env == :production) ? :production : :test
    
    warn "GoPay wasnt properly configured." if GoPay.configuration.goid.blank?
    configuration
  end

  class Configuration
    attr_accessor :environment, :goid, :success_url, :failed_url, :secure_key
    attr_reader   :country_codes, :messages

    def initialize
      @country_codes = YAML.load_file File.join(BASE_PATH, "config", "country_codes.yml")
      config    = YAML.load_file(File.join(BASE_PATH, "config", "config.yml"))
      @urls     = config["urls"]
      @messages = config["messages"]
    end

    def urls
      env = @environment.nil? ? "test" : @environment.to_s
      @urls[env]
    end
  end
end
