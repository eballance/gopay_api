require "yaml"

module GoPay

  BASE_PATH = File.expand_path("../../../", __FILE__)

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure_from_yaml(path)
    yaml = YAML.load_file(path)
    configuration.goid = yaml["goid"]
    configuration.success_url = yaml["success_url"]
    configuration.failed_url = yaml["failed_url"]
    configuration.secret = yaml["secret"]
  end

  class Configuration
    attr_accessor :environment, :goid, :success_url, :failed_url, :secret
    attr_reader :country_codes, :messages

    def initialize
      @environment ||= :production
      @country_codes = YAML.load_file File.join(BASE_PATH, "config", "country_codes.yml")
      config = YAML.load_file(File.join(BASE_PATH, "config", "config.yml"))
      @urls = config["urls"]
      @messages = config["messages"]
    end

    def urls
      @urls[@environment.to_s]
    end

  end

end
