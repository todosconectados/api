# frozen_string_literal: true

# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  # Mailer default settings
  default from: ENV['SES_FROM']
  layout 'mailer'

  # Delivers a new HTML email template for the given parameters
  # @param extension [User] - User instance
  # @return nil
  def email_conference_code(user)
    @user = user
    mail(
      to: user.email,
      subject: 'TodoConectados | Código de conferencia'
    )
  end
end
