class Conference < ApplicationRecord
  belongs_to :dialer

  validates :started_at, :ended_at, presence: true

end
