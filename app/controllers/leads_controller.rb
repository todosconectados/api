# frozen_string_literal: true

# Lead API endpoint
class LeadsController < ApplicationController
  # Generates a new +Lead+ for the given params.
  # @param [String] user[name] - User Name
  # @param [String] user[company_name] - Company name
  # @param [String] user[email] - Email
  # @param [String] user[phone] - Phone
  # @param [String] user[comments] - Activation code
  # @return [JSON] JSON response with the created object and status code
  #   or validation errors if any
  # @example
  # {
  #   "lead"=>
  #   {
  #     "id":9,
  #     "name":"Gustavo Montenegro Enríquez",
  #     "company_name":"Orchard Books",
  #     "email":"user_specs9_deandra@example.net",
  #     "phone":"7061219870",
  #     "comments":"I have one of a kind items.",
  #     "created_at":"2020-03-27T17:25:08.065-06:00",
  #     "updated_at":"2020-03-27T17:25:08.065-06:00"
  #   }
  # }
  def create
    lead = Lead.create! create_params
    lead.send_leads_contact_email!
    json_response lead, :created
  end

  private

  # returns a List of permitted HTTP Params for +Lead+ resource.
  # @return ActionController::Parameters
  # @private
  def create_params
    params.require(:leads).permit(
      :name,
      :company_name,
      :email,
      :phone,
      :comments
    )
  end
end
