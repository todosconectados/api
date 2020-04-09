# frozen_string_literal: true

# This class represents a ApiKey within the database.
# It contains all the information for api authentication via knock gem
class ApiKey < ApplicationRecord
  # updates an instance +api_key+ and +api_secret+ attributes with a random
  # generated secure unique value and an AuthToken generated via knock gem.
  # @return nil
  def generate_api_id_and_api_key
    self.api_id = SecureRandom.uuid
    self.api_key = Knock::AuthToken.new(
      payload: { api_id: api_id }
    ).token
  end
end
