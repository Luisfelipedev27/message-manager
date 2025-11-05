class Message < ApplicationRecord
  validates :subject, presence: true, length: { maximum: 220 }
  validates :body, presence: true

  after_create_commit :notify_slack

  private

  def notify_slack
    SlackNotificationService.new(self).call
  end
end
