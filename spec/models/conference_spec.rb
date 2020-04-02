require 'rails_helper'

RSpec.describe Conference, type: :model do
  describe 'validations' do
    it { should validate_presence_of :ended_at }
  end
end
