# frozen_string_literal: true

# Base Application Job definition. Defines shared methods and concerns.
class ApplicationJob < ActiveJob::Base
  include Errorable

  # global error handling for +StandardError+
  # errors are rendered with +json_response+
  # @return nil
  rescue_from StandardError do |e|
    Raven.capture_exception e
    raise e
  end

  # dummy method definition for +Errorable+ support.
  # logs the resulting error to rails logger.
  # @return nil
  def json_response(*args)
    object = args.first || {}
    Rails.logger.debug object.to_s
  end
end
