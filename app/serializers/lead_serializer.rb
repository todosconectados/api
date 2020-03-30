# frozen_string_literal: true

# +LeadSerializer+
class LeadSerializer < ApplicationSerializer
  attributes :name,
             :company_name,
             :email,
             :phone,
             :comments
end
