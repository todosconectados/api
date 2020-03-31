describe UsersController do
  describe 'POST /users' do
    let!(:url) { users_url }

    let!(:params) do
        {
          user: {
            name: 'Emmanuel Amaury',
            last_names: 'Fuentes Venegas',
            email: 'fuentesamaury@hotmail.com',
            phone: '4421304777'
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
          phone: '4421304777'
        },
        'g-recaptcha-response': '03AOLTBLT-RqJFh8sI7K6xUWHZaXYXq2UwaWPTyjlyl4MWNFwjq3l96uBzjfcObpeDYVPlzbLMPzDLSCE3snzhcU_tRLNCkLmGtR7yzjR4tKsTzCxPEsq7yQ1UHXhcVkyOAe0lpdJ43YOsqDKa74umr0g5v0vBU3JlnjewZExSytKORQjUTL6GjVYGHhIn_htaXAksZqcNeIo52-CMHEC-yjskqD03mBX6FcPi0yOrEq2F4Kx07raaS1FcWfLeA4RQtL7-HTgk14YsCUU4VvaYP0pWn-N4EoZIl0qMub7gyOKydXA55PR_h12arG08HCBKBY_JxSIURye2_Mep8TOaXzXjt2w147qqOq8W_eXe1RCBVqvrbeDVupT4vBuTFIebRsGAieqNY8tVtKBE2PDekHBVbDmxw1MLLv925SqScZuZCEcaWe4QscXoQ-jdpV48Ckm9E-kyIcioTAB1szvysUGd_6iMF4oUN_O2EpU-M1cfY4sWS01tf3BE5EMxltrrByM75S6HmZo5sxSNZOyQWOBZWkU-c8im_Q'
      }
    end

    let!(:invalid_recaptcha) do
      {
        user: {
          name: 'Emmanuel Amaury',
          last_names: 'Fuentes Venegas',
          email: 'fuentesamaury@hotmail.com',
          phone: '4421304777'
        },
        'g-recaptcha-response': '03AOLTBLT-RqJFh8sI7K6xUWHZaXYXq2UwaWPTyjlyl4MWNFwjq3l96uBzjfcObpeDYVPlzbLMPzDLSCE3snzhcU_tRLNCkLmGtR7yzjR4tKsTzCxPEsq7yQ1UHXhcVkyOAe0lpdJ43YOsqDKa74umr0g5v0vBU3JlnjewZExSytKORQjUTL6GjVYGHhIn_htaXAksZqcNeIo52-CMHEC-yjskqD03mBX6FcPi0yOrEq2F4Kx07raaS1FcWfLeA4RQtL7-HTgk14YsCUU4VvaYP0pWn-N4EoZIl0qMub7gyOKydXA55PR_h12arG08HCBKBY_JxSIURye2_Mep8TOaXzXjt2w147qqOq8W_eXe1RCBVqvrbeDVupT4vBuTFIebRsGAieqNY8tVtKBE2PDekHBVbDmxw1MLLv925SqScZuZCEcaWe4QscXoQ-jdpV48Ckm9E-kyIcioTAB1szvysUGd_6iMF4oUN_O2EpU-M1cfY4sWS01tf3BE5EMxltrrByM75S6HmZo5sxSNZOyQWOBZWkU-c8im_Q'
      }
    end

    it 'should create a valid user with a valid recaptcha' do
      VCR.use_cassette('grecaptcha_valid', match_requests_on: [:grecaptcha]) do
        VCR.use_cassette('notify_new_user_step1_to_slack',
          match_requests_on: [:slack_api]) do
          post url, params: params
        end
      end
      expect(response).to have_http_status(:created)
      user_data = json['user']
      expected_data = params[:user]
      expect(user_data['name']).to eq(expected_data[:name])
      expect(user_data['last_names']).to eq(expected_data[:last_names])
      expect(user_data['email']).to eq(expected_data[:email])
      expect(user_data['phone']).to eq(expected_data[:phone])
      expect(user_data['activation_code']).
        to eq(expected_data[:activation_code])
    end

    it 'should refuse to create a user with invalid params' do
      VCR.use_cassette('grecaptcha_valid', match_requests_on: [:grecaptcha]) do
        post url, params: invalid_params
        expect(response).to have_http_status(:bad_request)
      end
    end

    it 'should return a unprocesable entity response whit an invalid g-recaptcha' do
      VCR.use_cassette('grecaptcha_invalid', match_requests_on: [:grecaptcha]) do
        post url, params: invalid_recaptcha
      end
      # status code expectations
      expect(response).to have_http_status(422)
    end
  end

  describe 'POST /users/:id/validate' do
    let!(:user) do
      create :user,
      phone: '5522522113',
      email: 'fuentesamaury@hotmail.com'
    end

    let!(:url) do
      validate_user_url(user.id)
    end

    it 'should update validation code update phone and send sms with code' do
      VCR.use_cassette('user_send_sms_with_code',
        match_requests_on: [:marcatel_api]) do
        post url, params: { phone: '4421304777' }
      end
      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.activation_code).to be_present
    end

    it 'should return Record unprocessable_entity if phone not found' do
      post url, params: { phone: nil }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should return Record not found if status is different from step 1' do
      user.update! status: User::Status::TERMINATED
      post url, params: { phone: nil }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /users/:id/activate' do
    let!(:user) do
      create :user, phone: '5522522113', activation_code: '1234'
    end

    let!(:dialer) { create :dialer }

    let!(:url) { activate_user_url(user.id) }

    it 'should update user status to active if activation_code correct' do
      VCR.use_cassette('user_sended_email',
        match_requests_on: [:ses_api]) do
        VCR.use_cassette('user_send_sms_with_code',
          match_requests_on: [:marcatel_api]) do
          post url, params: { activation_code: '1234' }
        end
      end
      expect(response).to have_http_status(:ok)
      user_data = json['user']
      expect(user_data['id']).to eq(user.id)
      dialer_data = user_data['dialer']
      expect(dialer_data['did']).to eq(dialer.did)
      expect(dialer_data['conference_code']).to eq(dialer.conference_code)
      user.reload
      expect(user).to be_active
    end

    it 'should return Record not found if phone not found' do
      post url, params: { activation_code: 'abcd' }
      expect(response).to have_http_status(:not_found)
    end

    it 'should return Record not found if status is different from step 1' do
      user.update! status: User::Status::TERMINATED
      post url, params: { phone: nil }
      expect(response).to have_http_status(:not_found)
    end
  end
end
