module GoPay
  class Railtie < ::Rails::Railtie
    config.after_initialize do 
      GoPay.configure_from_rails
    end
  end
end
