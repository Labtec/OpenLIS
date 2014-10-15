require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module OpenLIS
  class Application < Rails::Application
    config.time_zone = 'Bogota'
    config.i18n.default_locale = :es
    config.active_record.raise_in_transactional_callbacks = true
  end
end
