# frozen_string_literal: true

# +ConferenceSerializer+
class ConferenceSerializer < ApplicationSerializer
  attributes :started_at,
             :ended_at,
             :pbx_id,
             :dialer_id
end
