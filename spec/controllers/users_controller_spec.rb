require 'spec_helper'

describe UsersController, type: :controller do
  describe 'POST /users' do
    let!(:url) do
      users_url
    end

    let!(:params) do
        {
          users: {
            name: 'Emmanuel Amaury',
            last_names: 'Fuentes Venegas',
            email: 'fuentesamaury@hotmail.com',
            phone: '4421304777',
            activation_code: '1234',
            business_name: 'Industries FactoryBot',
            state: 'qro'
          },
          'g-recaptcha-response': '03AOLTBLT-RqJFh8sI7K6xUWHZaXYXq2UwaWPTyjlyl4MWNFwjq3l96uBzjfcObpeDYVPlzbLMPzDLSCE3snzhcU_tRLNCkLmGtR7yzjR4tKsTzCxPEsq7yQ1UHXhcVkyOAe0lpdJ43YOsqDKa74umr0g5v0vBU3JlnjewZExSytKORQjUTL6GjVYGHhIn_htaXAksZqcNeIo52-CMHEC-yjskqD03mBX6FcPi0yOrEq2F4Kx07raaS1FcWfLeA4RQtL7-HTgk14YsCUU4VvaYP0pWn-N4EoZIl0qMub7gyOKydXA55PR_h12arG08HCBKBY_JxSIURye2_Mep8TOaXzXjt2w147qqOq8W_eXe1RCBVqvrbeDVupT4vBuTFIebRsGAieqNY8tVtKBE2PDekHBVbDmxw1MLLv925SqScZuZCEcaWe4QscXoQ-jdpV48Ckm9E-kyIcioTAB1szvysUGd_6iMF4oUN_O2EpU-M1cfY4sWS01tf3BE5EMxltrrByM75S6HmZo5sxSNZOyQWOBZWkU-c8im_Q'
        }
    end

    let!(:invalid_params) do
      {
        use: {
          name: 'Emmanuel Amaury',
          last_names: 'Fuentes Venegas',
          email: 'fuentesamaury@hotmail.com',
          phone: '4421304777',
          activation_code: '1234',
          business_name: 'Industries FactoryBot',
          state: 'qro'
        },
        'g-recaptcha-response': '03AOLTBLT-RqJFh8sI7K6xUWHZaXYXq2UwaWPTyjlyl4MWNFwjq3l96uBzjfcObpeDYVPlzbLMPzDLSCE3snzhcU_tRLNCkLmGtR7yzjR4tKsTzCxPEsq7yQ1UHXhcVkyOAe0lpdJ43YOsqDKa74umr0g5v0vBU3JlnjewZExSytKORQjUTL6GjVYGHhIn_htaXAksZqcNeIo52-CMHEC-yjskqD03mBX6FcPi0yOrEq2F4Kx07raaS1FcWfLeA4RQtL7-HTgk14YsCUU4VvaYP0pWn-N4EoZIl0qMub7gyOKydXA55PR_h12arG08HCBKBY_JxSIURye2_Mep8TOaXzXjt2w147qqOq8W_eXe1RCBVqvrbeDVupT4vBuTFIebRsGAieqNY8tVtKBE2PDekHBVbDmxw1MLLv925SqScZuZCEcaWe4QscXoQ-jdpV48Ckm9E-kyIcioTAB1szvysUGd_6iMF4oUN_O2EpU-M1cfY4sWS01tf3BE5EMxltrrByM75S6HmZo5sxSNZOyQWOBZWkU-c8im_Q'
      }
    end

    let!(:invalid_recaptcha) do
      {
        users: {
          name: 'Emmanuel Amaury',
          last_names: 'Fuentes Venegas',
          email: 'fuentesamaury@hotmail.com',
          phone: '4421304777',
          activation_code: '1234',
          business_name: 'Industries FactoryBot',
          state: 'qro'
        },
        'g-recaptcha-response': '03AOLTBLT-RqJFh8sI7K6xUWHZaXYXq2UwaWPTyjlyl4MWNFwjq3l96uBzjfcObpeDYVPlzbLMPzDLSCE3snzhcU_tRLNCkLmGtR7yzjR4tKsTzCxPEsq7yQ1UHXhcVkyOAe0lpdJ43YOsqDKa74umr0g5v0vBU3JlnjewZExSytKORQjUTL6GjVYGHhIn_htaXAksZqcNeIo52-CMHEC-yjskqD03mBX6FcPi0yOrEq2F4Kx07raaS1FcWfLeA4RQtL7-HTgk14YsCUU4VvaYP0pWn-N4EoZIl0qMub7gyOKydXA55PR_h12arG08HCBKBY_JxSIURye2_Mep8TOaXzXjt2w147qqOq8W_eXe1RCBVqvrbeDVupT4vBuTFIebRsGAieqNY8tVtKBE2PDekHBVbDmxw1MLLv925SqScZuZCEcaWe4QscXoQ-jdpV48Ckm9E-kyIcioTAB1szvysUGd_6iMF4oUN_O2EpU-M1cfY4sWS01tf3BE5EMxltrrByM75S6HmZo5sxSNZOyQWOBZWkU-c8im_Q'
      }
    end

    it 'should create a valid user with a valid recaptcha' do
      VCR.use_cassette('grecaptcha_valid', match_requests_on: [:grecaptcha]) do
        post :create, params: params
      end
      expect(response).to have_http_status(:created)
      user_data = json['user']
      expected_data = params[:users]
      expect(user_data['name']).to eq(expected_data[:name])
      expect(user_data['last_names']).to eq(expected_data[:last_names])
      expect(user_data['email']).to eq(expected_data[:email])
      expect(user_data['phone']).to eq(expected_data[:phone])
      expect(user_data['activation_code']).
        to eq(expected_data[:activation_code])
      expect(user_data['business_name']).to eq(expected_data[:business_name])
      expect(user_data['state']).to eq(expected_data[:state])
    end

    it 'should refuse to create a user with invalid params' do
      VCR.use_cassette('grecaptcha_valid', match_requests_on: [:grecaptcha]) do
        expect do
          post :create, params: invalid_params
        end.to raise_error(ActionController::ParameterMissing)
      end
    end

    it 'should return a unprocesable entity response whit an invalid g-recaptcha' do
      VCR.use_cassette('grecaptcha_invalid', match_requests_on: [:grecaptcha]) do
        post :create, params: invalid_recaptcha
      end
      # status code expectations
      expect(response).to have_http_status(422)
    end
  end

  describe 'POST /users/:id/validate' do
    let!(:user) do
      create :user,
      phone: '5522522113'
    end

    let!(:url) do
      validate_user_url(user.id)
    end

    let!(:params) do
      {
        phone: '4421304777'
      }
    end

    it 'should update validation code and update phone' do
      binding.pry
      post :validate , id: user.id, params: params
      binding.pry
    end
  end
end
