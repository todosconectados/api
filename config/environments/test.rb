# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}"
  }
  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :ses

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Url Host
  Rails.application.routes.default_url_options[:only_path] = true
  # ActiveJob Queue Adapter (we will need it)
  config.active_job.queue_adapter = :inline
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.secret_key = '712f7c717455371dce08a9d9acdef09036ab00d3c324d97c59bf4ea5d85cf34d4118c23a89db19ca923f8e14371dc63a556d0bc219d0865f3eec9159ef322a17'
end
