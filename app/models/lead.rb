# frozen_string_literal: true

# It contains all the information of the Lead
class Lead < ApplicationRecord
  validates :name, :phone, :comments, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { is: 10 }
end
