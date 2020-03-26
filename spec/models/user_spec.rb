require 'rails_helper'

RSpec.describe User, type: :model do
  # validations
  describe 'validations' do
    let!(:user) { create :user }

    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :target }
    it { should validate_presence_of :business_name }
    it { should validate_presence_of :state }
    it { should validate_length_of(:phone).is_equal_to 10 }

    it 'should return and error on invalid email' do
      user.email = "email"
      expect(user).to_not be_valid
      expect(user.errors.messages[:email]).to eq ['is invalid']
    end
  end
end
