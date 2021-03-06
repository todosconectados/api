# frozen_string_literal: true

describe User, type: :model do
  # validations
  describe 'validations' do
    let!(:user) { create :user }

    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_length_of(:phone).is_equal_to 10 }

    it { should validate_uniqueness_of(:email) }

    it 'should return error on invalid email' do
      user.email = 'email'
      expect(user).to_not be_valid
      expect(user.errors.messages[:email]).to eq ['es invalido']
    end
  end

  describe '#send_conference_code!' do
    let(:dialer) { create :dialer }
    let!(:user) do
      create :user, dialer: dialer, email: 'joel@thegurucompany.com'
    end

    it 'should send email to user' do
      VCR.use_cassette('user_send_sms_with_code',
                       match_requests_on: [:marcatel_api]) do
        VCR.use_cassette('user_send_conference_code_email',
                         match_requests_on: [:ses_api]) do
          user.send_conference_code!
        end
      end
    end
  end
end
