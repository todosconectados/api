# frozen_string_literal: true

# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.secret_key = ENV['GRECAPTCHA_KEY']
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
