class SlackNotificationService
  def initialize(message)
    @message = message
    @webhook_url = ENV['SLACK_WEBHOOK_URL']
  end

  def call
    return unless webhook_url.present?

    send_notification
  rescue StandardError => e
    Rails.logger.error("Slack notification failed: #{e.message}")
  end

  private

  attr_reader :message, :webhook_url

  def send_notification
    HTTParty.post(
      webhook_url,
      headers: { 'Content-Type' => 'application/json' },
      body: payload.to_json
    )
  end

  def payload
    {
      text: "New Message Created",
      blocks: [
        {
          type: "header",
          text: {
            type: "plain_text",
            text: "New Message Created"
          }
        },
        {
          type: "section",
          fields: [
            {
              type: "mrkdwn",
              text: "*Subject:*\n#{message.subject}"
            },
            {
              type: "mrkdwn",
              text: "*Created:*\n#{message.created_at.strftime('%Y-%m-%d %H:%M')}"
            }
          ]
        },
        {
          type: "section",
          text: {
            type: "mrkdwn",
            text: "*Body:*\n#{message.body}"
          }
        }
      ]
    }
  end
end
