# frozen_string_literal: true

# Conference API endpoint
class ConferencesController < ApplicationController
  before_action :assert_dialer!, only: %i[create]
  # Generates a new +conference+ for the given params.
  # @param [Integer] conference[pbx_id] - Conference Pbx ID
  # @param [Datetime] conference[started_at] - Conference started_at
  # @param [Datetime] conference[ended_at] - Conference ended_at
  # @return [JSON] JSON response with the created object and status code
  #   or validation errors if any
  # @example
  # {
  #   "conference"=>
  #   {
  #     "id"=>2,
  #     "started_at"=>"2018-12-04T17:19:26.596-06:00",
  #     "ended_at"=>"2018-12-04T17:19:26.596-06:00",
  #     "pbx_id"=>"1"
  #   }
  # }
  def create
    conference = Conference.create! create_params.merge(dialer: @dialer)
    json_response conference, :created
  end

  private

  # returns a List of permitted HTTP Params for +Conference+ resource.
  # @return ActionController::Parameters
  # @private
  def create_params
    params.require(:conference).permit(
      :started_at,
      :ended_at,
      :pbx_id
    )
  end

  # returns the Dialer finded by the given did parameter
  # @raise ActiveRecord::RecordNotFound
  # @return User
  def assert_dialer!
    @dialer = Dialer.active.find_by did: params[:did]
  end
end
