require 'rails_helper'

describe UsersController, type: :controller do
  describe 'POST /users' do
    let!(:url) do
      users_url
    end

    let!(:params) do
        {
          user: {
            name: 'Emmanuel Amaury',
            last_names: 'Fuentes Venegas',
            email: 'amaury@gurucomm.mx',
            phone: '4421304777',
            activation_code: '1234',
            business_name: 'Industries FactoryBot',
            state: 'qro'
          }
        }
    end


    it 'should create a valid user' do
      binding.pry
      post url, params: params
      expect(response).to have_http_status(:created)
    end
  end
end
