describe LeadsController do
  describe 'POST /leads' do
    let!(:url) { leads_url }

    let!(:params) do
        {
          lead: {
            name: 'Emmanuel Amaury Fuentes Venegas',
            company_name: 'Black Mesa',
            email: 'fuentesamaury@hotmail.com',
            phone: '4421304777',
            comments: 'You shall pass'
          }
        }
    end

    let!(:invalid_params) do
      {
        lea: {
          name: 'Emmanuel Amaury Fuentes Venegas',
          company_name: 'Black Mesa',
          email: 'fuentesamaury@hotmail.com',
          phone: '4421304777',
          comments: 'You shall NOT pass'
        }
      }
    end

    it 'should create a lead user' do
      VCR.use_cassette('leads_creation_sended_email',
        match_requests_on: [:ses_api]) do
          post url, params: params
      end
      expect(response).to have_http_status(:created)
      lead_data = json['lead']
      expected_data = params[:lead]
      expect(lead_data['name']).to eq(expected_data[:name])
      expect(lead_data['company_name']).to eq(expected_data[:company_name])
      expect(lead_data['email']).to eq(expected_data[:email])
      expect(lead_data['phone']).to eq(expected_data[:phone])
      expect(lead_data['comments']).to eq(expected_data[:comments])
    end

    it 'should refuse to create a user with invalid params' do
      post url, params: invalid_params
      expect(response).to have_http_status(:bad_request)
    end
  end
end
