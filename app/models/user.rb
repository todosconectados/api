class User < ApplicationRecord
  include Statable

  validates :name, :phone, :target, :business_name, :state, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { is: 10 }

  module Status
    STEP1 = :step1
    ACTIVE = :active
    TERMINATED = :terminated
    LIST = [
      STEP1,
      ACTIVE,
      TERMINATED
    ].freeze
  end

  module Target
    BUSINESS = :business
    ORGANIZATION = :organization
    PERSONAL = :personal
    LIST = [
      BUSINESS,
      ORGANIZATION,
      PERSONAL
    ].freeze
  end

  module Industry
    TBD = :tbd
    LIST = [
      TBD
    ].freeze
  end

  enum status: Status::LIST
  enum target: Target::LIST
  enum industry: Industry::LIST
end
