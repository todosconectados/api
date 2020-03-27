# frozen_string_literal: true

# +LeadSerializer+
class LeadSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :company_name,
             :email,
             :phone,
             :comments
end
