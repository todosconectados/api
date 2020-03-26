# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'action_mailer/railtie'
require 'action_controller/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TodosConectados
  # Rails Application Class
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib', 'writer')
    config.eager_load_paths << Rails.root.join('lib', 'writer')
    # Settings in config/environments/* take precedence
    # over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.logger = Logger.new(STDOUT)
    # config.log_level = :warn # In any environment initializer, or
    # Initialize Timezone
    config.time_zone = 'America/Mexico_City'
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 expose: %w[
                   Access-Control-Allow-Origin
                   access-token
                   expiry
                   token-type
                   uid
                   client
                 ],
                 methods: %i[get post patch delete options]
      end
    end
  end
end
