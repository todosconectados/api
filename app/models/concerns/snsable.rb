# frozen_string_literal: true

# +Snsable+ module.
module Snsable
  extend ActiveSupport::Concern
  include MarcatelSnsable

  included do
    # checks for the API to use for sending sns
    # @param [string] to -phone number endpoint, use the structure
    # country code +  phone number Eg. 524681192496
    # @param [string] message - body message
    # @return nil
    def send_sms!(to, message)
      marcatel_send_sms! [to], message
    end
  end
end
