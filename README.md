# Message Manager

Rails application for managing messages with automatic Slack notifications via webhook integration.

## Requirements

- Ruby 3.2.2
- PostgreSQL 14+
- Rails 8.0.4

## Installation

1. Install dependencies:
```bash
bundle install
```

2. Create environment variables file:
```bash
cp .env.example .env
```

3. Configure your Slack webhook URL in `.env`:
```
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

To obtain a Slack webhook URL:
- Visit https://api.slack.com/apps
- Create a new app and enable Incoming Webhooks
- Add a webhook to your desired workspace and channel
- Copy the webhook URL to your `.env` file

4. Setup database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

The seed command will output an API key for development use.

## Running the Application

You need to run two processes:

Terminal 1 - Rails server:
```bash
rails server
```

Terminal 2 - Tailwind CSS compiler:
```bash
rails tailwindcss:watch
```

Access the application at http://localhost:3000

## Features

- Full CRUD operations for messages (subject and body fields)
- Automatic Slack notifications when messages are created
- RESTful API with API key authentication
- Responsive web interface with Tailwind CSS
- PostgreSQL database

## API Usage

All API endpoints require authentication via the `X-API-Key` header.

Retrieve your API key:
```bash
rails console
ApiKey.first.token
```

### Endpoints

**List all messages**
```bash
curl -H "X-API-Key: YOUR_API_KEY" \
     http://localhost:3000/api/v1/messages
```

**Show a message**
```bash
curl -H "X-API-Key: YOUR_API_KEY" \
     http://localhost:3000/api/v1/messages/1
```

**Create a message**
```bash
curl -X POST \
     -H "X-API-Key: YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"message": {"subject": "Test Subject", "body": "Test body content"}}' \
     http://localhost:3000/api/v1/messages
```

**Update a message**
```bash
curl -X PATCH \
     -H "X-API-Key: YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     -d '{"message": {"subject": "Updated Subject"}}' \
     http://localhost:3000/api/v1/messages/1
```

**Delete a message**
```bash
curl -X DELETE \
     -H "X-API-Key: YOUR_API_KEY" \
     http://localhost:3000/api/v1/messages/1
```

### API Response Format

Success response example:
```json
{
  "id": 1,
  "subject": "Test Subject",
  "body": "Test body content",
  "created_at": "2025-11-05T10:30:00.000Z",
  "updated_at": "2025-11-05T10:30:00.000Z"
}
```

Error response example:
```json
{
  "errors": ["Subject can't be blank", "Body can't be blank"]
}
```

## Code Quality

Run RuboCop for code style checking:
```bash
bundle exec rubocop
```

## Project Structure

- `app/models/message.rb` - Message model with validations
- `app/models/api_key.rb` - API key model for authentication
- `app/controllers/messages_controller.rb` - Web interface controller
- `app/controllers/api/v1/messages_controller.rb` - API controller
- `app/services/slack_notification_service.rb` - Slack integration service
- `app/views/messages/` - Web interface views
- `app/views/api/v1/messages/` - API JSON views (Jbuilder)

## Technology Stack

- Ruby on Rails 8.0.2
- PostgreSQL
- Tailwind CSS
- HTTParty (Slack webhook requests)
- Jbuilder (JSON API responses)
- Dotenv (environment variables)
