require "yaml"

module GoPay

  module Config
    extend self

    BASE_PATH = File.expand_path("../../../", __FILE__)

    attr_reader :country_codes, :urls

    def self.init(environment = "production", &block)
      @country_codes = YAML.load_file File.join(BASE_PATH, "config", "country_codes.yml")
      @urls = YAML.load_file(File.join(BASE_PATH, "config", "config.yml"))[environment]
      instance_eval &block if block_given?
    end
  end
end
