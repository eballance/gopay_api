require "yaml"

module GoPay

  BASE_PATH = File.expand_path("../../../", __FILE__)

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_accessor :environment, :goid
    attr_reader :country_codes

    def initialize
      @environment ||= :production
      @country_codes = YAML.load_file File.join(BASE_PATH, "config", "country_codes.yml")
      @urls = YAML.load_file(File.join(BASE_PATH, "config", "config.yml"))
    end

    def urls
      @urls[@environment.to_s]
    end

  end

end
