require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  describe 'validations' do
    subject { create(:api_key) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:token) }
  end

  describe 'scopes' do
    let!(:active_key) { create(:api_key, active: true) }
    let!(:inactive_key) { create(:api_key, active: false) }

    it 'returns only active keys' do
      expect(ApiKey.active).to include(active_key)
      expect(ApiKey.active).not_to include(inactive_key)
    end
  end

  describe 'token generation' do
    it 'generates a token on create' do
      api_key = create(:api_key, token: nil)
      expect(api_key.token).to be_present
      expect(api_key.token.length).to eq(64)
    end

    it 'does not override existing token' do
      existing_token = SecureRandom.hex(32)
      api_key = create(:api_key, token: existing_token)
      expect(api_key.token).to eq(existing_token)
    end
  end
end
