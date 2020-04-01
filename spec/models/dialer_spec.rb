# frozen_string_literal: true

describe Dialer, type: :model do
  # validations
  describe 'validations' do
    it { should belong_to :user }
  end
end
