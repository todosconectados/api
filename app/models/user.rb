# frozen_string_literal: true

# It contains all the information of the user
class User < ApplicationRecord
  include Slackable
  include Snsable

  has_one :dialer, dependent: :nullify

  validates :name, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: true
  validates :phone, length: { is: 10 }

  module Status
    STEP1 = :step1
    INTERMEDIATE = :intermediate
    ACTIVE = :active
    TERMINATED = :terminated
    LIST = {
      STEP1 => 0,
      INTERMEDIATE => 1,
      ACTIVE => 2,
      TERMINATED => 3
    }.freeze
  end

  enum status: Status::LIST

  # creates a 4 length random code based on the given generation properties
  # should be called in a +put cotroller action+
  # @return [bool] - status of the operation
  def generate_activation_code!
    self[:activation_code] = RandomPasswordGenerator.generate(
      4, skip_upper_case: true, skip_symbols: true, skip_url_unsafe: true
    )
    self[:status] = Status::INTERMEDIATE
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

  # Last step for SIGNUP, it assigns a reserved DIALER and update
  # +user+ status to active
  # return true
  def complete_and_asign_dialer!
    dialers = Dialer.reserved
    dialer = if dialers.any?
               dialers.sample
             else
               dialers.first!
             end
    update! status: User::Status::ACTIVE, dialer: dialer
    dialer.update! status: Dialer::Status::ACTIVE
  end

  # build message and send to slack channel
  # @return nil
  def notify_slack!
    post_to_slack(
      ENV['USER_SIGNUP_CHANNEL'],
      to_slack_notification!
    )
  end

  # name and last_name
  # @return String
  def full_name
    "#{name} #{last_names}"
  end

  # returns an ActiveRecord::Relation of +User+ instances filtered by
  # +start_date+ and +end_date+ params on
  # the created_at value
  # @param [DateTime] - start_date
  # @param [DateTime] - end_date
  # @return ActiveRecord::Relation
  def self.filter_by_created_at(start_date, end_date)
    result = where(nil)
    if start_date.present?
      start_date = Time.zone.parse(start_date)
      result = result.where(
        'users.created_at >= ?', start_date.beginning_of_day
      )
    end
    if end_date.present?
      end_date = Time.zone.parse(end_date)
      result = result.where(
        'users.created_at <= ?', end_date.end_of_day
      )
    end
    result
  end

  # returns an ActiveRecord::Relation of +User+ instances filtered by
  # +start_date+ and +end_date+ params run through filter_by_created_at
  # and filter_by_waiting_list_payed_at
  # @param [DateTime] - start_date
  # @param [DateTime] - end_date
  # @return ActiveRecord::Relation
  def self.filter_by_date(start_date, end_date)
    result = filter_by_created_at(start_date, end_date)
    result
  end

  private

  # build slack message
  # @return Hash - Slack Message
  def to_slack_notification!
    fields = [
      field('ID', id, true),
      field('Nombre', full_name, true),
      field('Teléfono', phone, true),
      field('Correo electronico', email, true),
      field('Status', status, true),
      field('Fecha de creación', created_at, true),
      field('Fecha de ultima actualización', updated_at, true)
    ]
    color = Priority.color 2
    {
      text: 'Nuevo registro de usuario',
      attachments: [{ color: color, fields: fields }]
    }
  end
end
