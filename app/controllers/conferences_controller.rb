class ConferencesController < ApplicationController
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
    user = User.create! create_params
    user.notify_slack!
    json_response user, :created
  end
end
