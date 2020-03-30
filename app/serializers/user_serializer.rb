# frozen_string_literal: true

# +UserSerializer+
class UserSerializer < ApplicationSerializer
  attributes :name,
             :last_names,
             :email,
             :phone,
             :status,
             :activation_code
end
