require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:subject).is_at_most(220) }
  end

  describe 'callbacks' do
    let(:message) { build(:message) }
    let(:slack_service) { instance_double(SlackNotificationService) }

    before do
      allow(SlackNotificationService).to receive(:new).with(message).and_return(slack_service)
      allow(slack_service).to receive(:call)
    end

    it 'calls SlackNotificationService after create' do
      message.save
      expect(SlackNotificationService).to have_received(:new).with(message)
      expect(slack_service).to have_received(:call)
    end
  end
end
