# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# use `active_model_serializers` for JSON serialization
gem 'active_model_serializers', '~> 0.10.6'
# use `dotenv-rails` for ENV variable management
gem 'dotenv-rails', '~> 2.7.2'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# use `aws-ses` for Transactional Email Deliveries
gem 'aws-ses', '~> 0.6.0', require: 'aws/ses'
# WDSL client
gem 'savon', '~> 2.12.0'
# Use `random_password_generator` for Password management
gem 'random_password_generator', '~> 1.0.0'
# use `rack-cors` for HTTP cors support
gem 'rack-cors', '~> 1.0.1'
# use grecaptcha for bot request prevention
gem 'recaptcha', '~> 4.3.1', require: 'recaptcha/rails'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # use capistrano for deployment
  gem 'capistrano', '= 3.10.0'
  gem 'capistrano-docker', github: 'netguru/capistrano-docker'
  gem 'capistrano-env-config', '~> 0.3.0'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rails-dotenv', '~> 0.0.3', require: false
  gem 'capistrano-rvm', '~> 0.1'
  gem 'capistrano-sidekiq', '~> 1.0.0'
  # use rspec for unit and integration tests
  gem 'factory_bot_rails', '~> 5.0.2'
  gem 'rspec-rails', '~> 3.7.1'
  # ruby code style fixing
  gem 'rubocop-rails', '~> 2.3.2', require: false
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner'
  # use faker to generate model factories
  gem 'faker', '~> 1.9.3'
  # debugging
  gem 'pry-rails', '~> 0.3.6'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'selenium-webdriver'
  # use VCR for remote API interactions
  gem 'vcr', '~> 3.0.3'
  # use shoulda-matchers to enforce unit test within models
  gem 'shoulda-matchers', '~> 3.1'
  # enable mocks within context examples
  gem 'webmock', '~> 3.5.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
