require "yaml"

module GoPay

  class Config

    BASE_PATH = File.expand_path("../../../", __FILE__)

    attr_accessor :country_codes, :urls

    def initialize(environment = "production")
      @country_codes = YAML.load_file File.join(BASE_PATH, "config", "country_codes.yml")
      @urls = YAML.load_file(File.join(BASE_PATH, "config", "config.yml"))[environment]
    end
  end
end
