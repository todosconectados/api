require 'rails_helper'

describe ConferencesController do
  describe 'POST /users' do
    let!(:url) { conferences_url }
    let!(:dialer) do
      create :dialer,
      status: :active
    end

    let!(:params) do
        {
          conference: {
            ended_at: Time.current.advance(minutes: 5),
            pbx_id: '5'
          },
          did: dialer.did
        }
    end

    let!(:invalid_params) do
      {
        conference: {
          ended_at: Time.current.advance(minutes: 5),
          pbx_id: '5'
        },
      }
    end

    it 'should create a valid conference' do
      post url, params: params
      expect(response).to have_http_status(:created)
      conference_data = json['conference']
      expected_data = params[:conference]
      expect(conference_data['ended_at']).to be_present
      expect(conference_data['pbx_id'].to_s).to eq(expected_data[:pbx_id])
      expect(conference_data['dialer_id']).to eq(dialer.id)
    end

    it 'should refuse to create a user with invalid params' do
      post url, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
