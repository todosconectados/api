# frozen_string_literal: true

# Dialers Class
class Dialer < ApplicationRecord
  belongs_to :user, optional: true

  # enum modules
  module Status
    RESERVED = :reserved
    INACTIVE = :inactive
    ACTIVE = :active
    LIST = [RESERVED, INACTIVE, ACTIVE].freeze
  end

  enum status: Status::LIST
end
