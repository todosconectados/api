# frozen_string_literal: true

# +PreventiveReviewJob+ Send notifications to inactive users
class PreventiveReviewJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    dialers = Dialer.active
    dialers.each do |dialer|
      user = dialer.user
      next unless sendeable?(dialer)

      ApplicationMailer.preventive_review_email(user).deliver_later
      user.update!(
        notifications_sent: User::NotificationType::NO_USAGE_WARNING
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

    from_date = Time.current.advance(days: -5).beginning_of_day
    to_date = Time.current.end_of_day

    user = dialer.user
    status = expiration_date.between?(from_date, to_date)
    condition = user.notifications_sent &
                User::NotificationType::NO_USAGE_WARNING

    !status && condition != User::NotificationType::NO_USAGE_WARNING
  end
end
