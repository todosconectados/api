describe LeadsController do
  describe 'POST /leads' do
    let!(:url) { leads_url }

    let!(:params) do
        {
          leads: {
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
      post url, params: params
      expect(response).to have_http_status(:created)
      lead_data = json['lead']
      expected_data = params[:leads]
      expect(lead_data['name']).to eq(expected_data[:name])
      expect(lead_data['company_name']).to eq(expected_data[:company_name])
      expect(lead_data['email']).to eq(expected_data[:email])
      expect(lead_data['phone']).to eq(expected_data[:phone])
      expect(lead_data['comments']).to eq(expected_data[:comments])
    end

    it 'should refuse to create a user with invalid params' do
      expect do
        post url, params: invalid_params
      end.to raise_error(ActionController::ParameterMissing)
    end
  end
end
