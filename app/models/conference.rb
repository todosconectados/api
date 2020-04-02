# frozen_string_literal: true

# It contains all the information of the Conference
class Conference < ApplicationRecord
  belongs_to :dialer

  validates :ended_at, presence: true
end
