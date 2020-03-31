# frozen_string_literal: true

require 'open-uri'
# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  # Mailer default settings
  default from: ENV['SES_FROM']
  layout 'mailer'

  before_action :set_links!
  before_action :attach_images!

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

  def leads_contact_email(lead)
    @lead = lead
    mail(
      to: ENV['LEAD_RECIPIENTS'],
      subject: 'TodoConectados | Contacto'
    )
  end

  private

  def set_links!
    @landing_url = ENV['LANDING_URL']
  end

  # adds social media icons to the emails that use them
  # @return nil
  # @private
  def attach_images!
    attachments.inline['tc-main-logo.png'] =
      email_cdn_file '/img/tc-main-logo.png'
    attachments.inline['corazon.png'] = email_cdn_file '/img/corazon.png'
  end

  # reads and returns the file at ENV['EMAIL_CDN_URL'] + path
  # @param path [string] - file path
  # @return File
  # @private
  def email_cdn_file(path)
    read_url_file ENV['EMAIL_CDN_URL'] + path
  end

  # reads and returns the file at the given url
  # @param url [string] - url
  # @return File
  # @private
  def read_url_file(url)
    uri = URI.parse url
    uri.read
  end
end
