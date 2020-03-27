# frozen_string_literal: true

# It contains all the information of the user
class User < ApplicationRecord
  include Statable
  include Snsable

  has_one :dialer, dependent: :destroy

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
  def generate_activation_code!
    self[:activation_code] = RandomPasswordGenerator.generate(
      4, skip_upper_case: true, skip_symbols: true, skip_url_unsafe: true
    )
    save!
  end

  # send a sms to user to verify the given mobile_phone
  # @return nil
  def send_activation_code!
    message = I18n.t(
      'notifications.activation_message.message',
      activation_code: activation_code
    )
    send_sms! phone, message
  end

  # Sends a notification with conference_code to a client via sms and email
  # @return nil
  def send_conference_code!
    send_sms!(
      self[:phone],
      I18n.t('activerecord.attributes.concern.sns_snsable.conference_code',
             phone: phone, conference_code: dialer.conference_code)
    )
    ApplicationMailer.email_conference_code(self).deliver_later
  end

  def complete_and_asign_dialer!
    dialer = Dialer.reserved.first!
    update!(status: User::Status::ACTIVE, dialer: dialer)
  end
end
