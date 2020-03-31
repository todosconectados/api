# frozen_string_literal: true

# +UserSerializer+
class UserSerializer < ApplicationSerializer
  attributes :name,
             :last_names,
             :email,
             :phone,
             :status,
             :activation_code,
             :dialer

  def dialer
    return if object.dialer.nil?

    DialerSerializer.new(object.dialer).as_json
  end
end
