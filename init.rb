require "gopay"

config.after_initialize { GoPay.configure_from_rails if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3 }
