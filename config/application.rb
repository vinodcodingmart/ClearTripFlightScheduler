require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CtFlights
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += %W(#{config.root}/lib)

    config.autoload_paths += Dir[File.join("#{Rails.root.to_s}", 'app', 'workers', "Shared")]
    config.autoload_paths += Dir[File.join("#{Rails.root.to_s}", 'app', 'workers', "**","*")]
    config.autoload_paths += Dir[File.join("#{Rails.root.to_s}", 'lib',"*")]

    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = [:hi, :en, :ar]
    #config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    #config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]
    config.i18n.load_path += Dir[File.join("#{Rails.root.to_s}", 'config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true
    # config.assets.prefix = "/assets"
    config.cache_store = :redis_store, {
        host: 'localhost',
        port: 6379,
        namespace: "cache",
        expires_in: 1.day
    }
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
