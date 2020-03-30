# frozen_string_literal: true

# Testing Helpers
module SpecHelper
  # invokes a VCR +use_cassette+ method for an eligible `FactoryBot` method
  # @param method [String] - FactoryBot method name
  # @param factory_key [String] - FactoryBot factory name
  # @param cassette [String] - VCR cassette name
  # @param params [Hash] - FactoryBot Parameters
  # @return nil
  def wrap_around_cassette(method, factory_key, cassette, params = {})
    VCR.use_cassette(cassette, match_requests_on: [:s3_api]) do
      FactoryBot.send method, factory_key, params
    end
  end
end
