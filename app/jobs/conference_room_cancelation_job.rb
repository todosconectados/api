# frozen_string_literal: true

# +ConferenceRoomCancelationJob+ Send notifications and terminate users
class ConferenceRoomCancelationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    dialers = Dialer.active
    dialers.each do |dialer|
      user = dialer.user
      next unless sendeable?(dialer)

      ApplicationMailer.cancelation_conference_room_email(user).deliver_later
      dialer.update! status: Dialer::Status::RESERVED
      user.update!(
        notifications_sent: User::NotificationType::NO_USAGE_TERMINATION,
        dialer: nil
      )
    end
  end

  def sendeable?(dialer)
    last_conference = dialer.conferences.last
    expiration_date = if last_conference.present?
                        last_conference.started_at
                      else
                        dialer.assigned_at
                      end

    from_date = Time.current.advance(days: -7).beginning_of_day
    to_date = Time.current.end_of_day

    user = dialer.user
    status = expiration_date.between?(from_date, to_date)

    condition = user.notifications_sent &
                User::NotificationType::NO_USAGE_TERMINATION

    !status && condition != User::NotificationType::NO_USAGE_TERMINATION
  end
end
