# frozen_string_literal: true

# It contains all the information of the user
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

  # creates a 4 length random code based on the given generation properties
  # should be called in a +put cotroller action+
  # @return [bool] - status of the operation
  def generate_support_code!
    self[:activation_code] = RandomPasswordGenerator.generate(
      4, skip_upper_case: true, skip_symbols: true, skip_url_unsafe: true
    )
    save!
  end
end
