# frozen_string_literal: true

# +Errorable+ module. Global Application error handling
module Errorable
  extend ActiveSupport::Concern

  included do
    # global error handling fot +ActiveRecord::RecordNotFound+
    # renders a 404 status and terminates the current request
    # @return nil
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    # global error handling for +ActiveRecord::RecordNotFound+
    # Validation errors are rendered with `ErrorSerializer`
    # @return nil
    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response(
        e.record,
        :unprocessable_entity,
        adapter: :attributes,
        serializer: ErrorSerializer
      )
    end

    # global error handling for +ArgumentError+
    # @return nil
    rescue_from ArgumentError do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    # global error handling for +ActionController::BadRequest+.
    # Captures error via +Raven+ and returns a JSON response with HTTP 400
    #   status code.
    # @return nil
    rescue_from ActionController::BadRequest do |e|
      json_response(
        { message: e.message },
        :bad_request
      )
    end

    # global error handling for +ActionController::ParameterMissing+
    # Validation errors are rendered with +json_response+
    # @return nil
    rescue_from ActionController::ParameterMissing do |e|
      json_response({ message: e.message }, :bad_request)
    end
  end
end
