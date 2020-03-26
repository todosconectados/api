# frozen_string_literal: true

# User API endpoint
class UsersController < ApplicationController
  before_action :validate_recaptcha!, only: %i[create]
  # Generates a new +User+ for the given params.
  # @param [String] user[name] - User Name
  # @param [String] user[last_names] - User Last name
  # @param [String] user[email] - Email
  # @param [String] user[phone] - Phone
  # @param [String] user[business_name] - Business name
  # @param [String] user[state] - State
  # @param [String] user[activation_code] - Activation code
  # @return [JSON] JSON response with the created object and status code
  #   or validation errors if any
  # @example
  # {
  #   "user"=>
  #   {
  #     "id"=>2,
  #     "updated_at"=>"2018-12-04T17:19:26.596-06:00",
  #     "created_at"=>"2018-12-04T17:19:26.596-06:00",
  #     "name"=>"Sta. Ana Luisa Rocha Burgos",
  #     "last_names"=>"Alcaraz",
  #     "email"=>"brielle@example.com",
  #     "phone"=>"9952259424",
  #     "status"=>nil,
  #     "business_name"=>nil,
  #     "activation_code"=>1234,
  #     "target"=>"business",
  #     "industry"=>"tbd",
  #     "state"=>"qro"
  #   }
  # }
  def create
    user = User.create! create_params
    json_response user, :created
  end

  private

  def create_params
    params.require(:users).permit(
      :name,
      :last_names,
      :email,
      :phone,
      :activation_code,
      :business_name,
      :state
    )
  end
end
