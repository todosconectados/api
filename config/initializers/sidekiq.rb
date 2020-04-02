# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

if ENV['SIDEKIQ_REDIS'].present?
  Sidekiq.default_worker_options = { retry: false }
  if Rails.env.production?
    Sidekiq::Cron::Job.load_from_hash YAML.load_file('config/schedule.yml')
  end
end
