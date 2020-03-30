# frozen_string_literal: true

# Base Application Controller definition. Contains shared methods and concerns.
class ApplicationController < ActionController::API
  include Recaptcha::Verify
  include Errorable

  protected

  # serialized the given ruby +Object+ to a JSON response for an optional
  # HTTP +status+ attribute.
  # When this method is called, response is terminated.
  # @return nil
  def json_response(object, status = :ok, args = {})
    args = {} if args.nil?
    args[:status] = status
    args[:json] = object
    render args
  end

  # given an HTTP Request, this method validates a given Google Recaptcha
  # response via +recaptcha+ gem.
  # If validation fails, the request will be terminated and an HTTP 422 status
  # code will be rendered.
  # This method should be called as part of a +before_action+ filter
  # @return nil
  def validate_recaptcha!
    return if verify_recaptcha

    json_response({ message: 'Invalid Recaptcha' }, :unprocessable_entity)
  end
end
