# frozen_string_literal: true

# +UserSerializer+
class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :last_names,
             :email,
             :phone,
             :status,
             :activation_code,
             :target,
             :business_name,
             :industry,
             :state
end
