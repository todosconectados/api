# frozen_string_literal: true

describe Lead, type: :model do
  describe 'validations' do
    let!(:user) { create :user }

    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :comments }
    it { should validate_length_of(:phone).is_equal_to 10 }

    it 'should return error on invalid email' do
      user.email = 'email'
      expect(user).to_not be_valid
      expect(user.errors.messages[:email]).to eq ['es invalido']
    end
  end

  describe '#send_leads_contact_email!' do
    let!(:lead) { create :lead }

    it 'should send email to Lead User' do
      VCR.use_cassette('leads_creation_email',
                       match_requests_on: [:ses_api]) do
        lead.send_leads_contact_email!
      end
    end
  end
end
