# frozen_string_literal: true

# It contains all the information of the user
class User < ApplicationRecord
  include Snsable

  has_one :dialer, dependent: :destroy

  validates :name, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: true
  validates :phone, length: { is: 10 }

  module Status
    STEP1 = :step1
    ACTIVE = :active
    TERMINATED = :terminated
    LIST = { STEP1 => 0, ACTIVE => 1, TERMINATED => 2 }.freeze
  end

  enum status: Status::LIST

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
             did: dialer.did, conference_code: dialer.conference_code)
    )
    ApplicationMailer.email_conference_code(self).deliver_later
  end

  def complete_and_asign_dialer!
    dialers = Dialer.reserved
    dialer = if dialers.any?
               dialers.sample
             else
               dialers.first!
             end
    update!(status: User::Status::ACTIVE, dialer: dialer)
  end
end
