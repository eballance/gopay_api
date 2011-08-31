module GoPay

  class Railtie < ::Rails::Railtie
    config.after_initialize do

      GoPay.configure_from_rails
      Rails.logger.info "** couch_potato: initialized from #{__FILE__}"

    end
  end

end