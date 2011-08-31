require "gopay"

if defined?(::Rails) && ::Rails::VERSION::MAJOR >= 3
  config.after_initialize { GoPay.configure_from_rails; Rails.logger.info "** couch_potato: initialized from #{__FILE__}" }
end


