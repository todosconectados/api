# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if
  Rails.env.production?
require 'rspec/rails'
require 'database_cleaner'
require 'webmock/rspec'

# include all support classes
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
# disable HTTP connections
WebMock.disable_net_connect!
# enable Recaptcha in testing environment
Recaptcha.configuration.skip_verify_env.delete('test')
# VCR config
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  # google recaptcha
  config.register_request_matcher :grecaptcha do |real_request, recorded_request|
    url_regex = /^https:\/\/www.google.com\/recaptcha\/api\/siteverify.*$/
    real_request.uri == recorded_request.uri || (
      url_regex.match(real_request.uri) &&
      url_regex.match(recorded_request.uri)
    )
  end

  # Marcatel API
  config.register_request_matcher :marcatel_api do |real_request, recorded_request|
    url_regex = /^https:\/\/b2c.marcatel.com.mx.*$/
    (real_request.uri == recorded_request.uri) ||
      (
        url_regex.match(real_request.uri) &&
        url_regex.match(recorded_request.uri)
      )
  end

  # aws ses API
  config.register_request_matcher :ses_api do |real_request, recorded_request|
    url_regex = /^https:\/\/email\.us-west-2\.amazonaws\.com.*$/
    s3_url_regex = /^https:\/\/.*\.s3-us-west-2\.amazonaws\.com.*$/
    (real_request.uri == recorded_request.uri) ||
      (
        url_regex.match(real_request.uri) &&
        url_regex.match(recorded_request.uri)
      ) ||
      (
        s3_url_regex.match(real_request.uri) &&
        s3_url_regex.match(recorded_request.uri)
      )
  end

  # slack api
  config.register_request_matcher :slack_api do |real_request, recorded_request|
    url_regex = /^https:\/\/slack\.com\/api.*$/
    real_request.uri == recorded_request.uri ||
      (
        url_regex.match(real_request.uri) &&
        url_regex.match(recorded_request.uri)
      )
  end
end

RSpec.configure do |config|
  # add `FactoryBot` methods
  config.include FactoryBot::Syntax::Methods
  # add Route helpers
  config.include Rails.application.routes.url_helpers
  # include RequestSpecHelper
  config.include RequestSpecHelper
  # include SpecHelper
  config.include SpecHelper
  # Helpers
  # config.include Requests::AuthHelpers::Includables, type: :request
  # config.extend Requests::AuthHelpers::Extensions, type: :request
  # start by truncating all the tables but then use the faster transaction
  # strategy the rest of the time.
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  # start the transaction strategy as examples are run
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

# configure shoulda matchers to use rspec as the test framework and full matcher
# libraries for rails
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
