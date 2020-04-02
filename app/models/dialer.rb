# frozen_string_literal: true

# Dialers Class
class Dialer < ApplicationRecord
  belongs_to :user, optional: true
  has_many :conferences, dependent: :destroy
  # enum modules
  module Status
    RESERVED = :reserved
    INACTIVE = :inactive
    ACTIVE = :active
    LIST = { RESERVED => 0, ACTIVE => 1, INACTIVE => 2 }.freeze
  end

  enum status: Status::LIST
end
