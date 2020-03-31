# frozen_string_literal: true

# User API endpoint
class UsersController < ApplicationController
  before_action :validate_recaptcha!, only: %i[create]
  before_action :assert_user!, only: %i[validate]
  before_action :assert_user_with_activation_code!, only: %i[activate]
  # Generates a new +User+ for the given params.
  # @param [String] user[name] - User Name
  # @param [String] user[last_names] - User Last name
  # @param [String] user[email] - Email
  # @param [String] user[phone] - Phone
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
  #     "activation_code"=>1234,
  #   }
  # }
  def create
    user = User.create! create_params
    user.notify_slack!
    json_response user, :created
  end

  # Generates a new +User+ for the given params.
  # @param [String] user[phone] - Phone
  # @param [String] user[activation_code] - Activation code
  # @return [JSON] JSON response with http status 200
  # or validation errors if any
  def activate
    @user.complete_and_asign_dialer!
    @user.send_conference_code!
    json_response @user
  end

  # Generates a new +User+ for the given params.
  # @param [String] user[phone] - Phone
  # @return [JSON] JSON response with http status 200
  # or validation errors if any
  def validate
    @user.update! phone: params[:phone]
    @user.generate_activation_code!
    @user.send_activation_code!
    head :ok
  end

  private

  # returns a List of permitted HTTP Params for +User+ step1 resource.
  # @return ActionController::Parameters
  # @private
  def create_params
    params.require(:user).permit(
      :name,
      :last_names,
      :email,
      :phone
    )
  end

  # returns the current user finded by the given id HTTP parameter
  # @raise ActiveRecord::RecordNotFound
  # @return User
  def assert_user!
    @user = User.step1.find params[:id]
  end

  # returns the current user finded by the given id HTTP parameter
  #  and should match with the activation_code param
  # @raise ActiveRecord::RecordNotFound
  # @return User
  def assert_user_with_activation_code!
    @user = User.step1.find_by!(
      id: params[:id],
      activation_code: params[:activation_code]
    )
  end
end
