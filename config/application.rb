# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TodosConectados
  # Rails Application Class
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib', 'marcatel')
    config.eager_load_paths << Rails.root.join('lib', 'marcatel')
    # Settings in config/environments/* take precedence
    # over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.logger = Logger.new(STDOUT)
    # config.log_level = :warn # In any environment initializer, or
    # Initialize Timezone
    config.time_zone = 'America/Mexico_City'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :classic
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.filter_parameters << :password
    # sentry config
    # comment these lines out if integration with sentry is required
    Raven.configure do |config|
      config.dsn = ENV['SENTRY_DSN']
      config.sanitize_fields = Rails
                               .application
                               .config
                               .filter_parameters
                               .map(&:to_s)
      config.silence_ready = Rails.env.test? || Rails.env.development?
    end
    # i18n config
    config.i18n.default_locale = :es
  end
end
