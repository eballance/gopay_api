require "yaml"
require "singleton"

module GoPay

  class Config
    include ::Singleton

    BASE_PATH = File.expand_path("../../../", __FILE__)

    attr_reader :country_codes, :config

    def initialize(env = "test")
      @country_codes = YAML.load_file File.join(BASE_PATH, "config", "country_codes.yml")
      @config = YAML.load_file(File.join(BASE_PATH, "config", "config.yml"))[env.to_s]
    end

  end
end
