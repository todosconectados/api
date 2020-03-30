# frozen_string_literal: true

# +RegexComparable+
module RegexComparable
  extend ActiveSupport::Concern

  included do
    # regex to generate a valid phone number for marcatel
    MARCATEL_VALID_PHONE = /\A.*([0-9]{10})$/.freeze
  end
end
