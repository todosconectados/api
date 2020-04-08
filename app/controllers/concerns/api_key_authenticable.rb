# frozen_string_literal: true

# +ApiKeyAuthenticable+ module
module ApiKeyAuthenticable
  extend ActiveSupport::Concern
  # include Knock::Authenticable

  protected

  # authenticates the current HTTP request for devise and knock for the given
  # HTTP context.
  # For devise, request is authenticated via +devise_token_auth+ header
  # validation.
  # For knock, request is authenticated via Authorization Bearer Helper
  # Terminates response with unauthorized header if both methods fail
  # @return nil
  def authenticate_api_key!
    return if current_auth_api_key.present?

    render nothing: true, status: :unauthorized
  end

  # return the current authenticated api_key validated via Knock
  # authentication.
  # If request is not authenticated nil is returned
  # @return Apikey - authenticated company
  def current_auth_api_key
    @current_auth_api_key ||= lambda do
      authenticate_knox_api_key!
      api_key
    end.call
  end

  # Authenticates the current request for a ApiKey model context.
  # @return nil.
  def authenticate_knox_api_key!
    authenticate_for ApiKey
  end

  # Fetch the auth +ApiKey+ from the request headers
  # @return +ApiKey+ or nil
  def api_key
    request.headers['HTTP_AUTHORIZATION']
  end
end
