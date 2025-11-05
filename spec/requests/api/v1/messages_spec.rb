require 'rails_helper'

RSpec.describe "Api::V1::Messages", type: :request do
  let(:api_key) { create(:api_key, active: true) }
  let(:headers) { { "X-API-Key" => api_key.token, "Content-Type" => "application/json", "Accept" => "application/json" } }
  let(:valid_attributes) do
    { subject: "Test Subject", body: "Test Body" }
  end
  let(:invalid_attributes) do
    { subject: "", body: "" }
  end

  before do
    stub_request(:post, ENV['SLACK_WEBHOOK_URL'] || "https://hooks.slack.com/test")
      .to_return(status: 200, body: "", headers: {})
  end

  describe "GET /api/v1/messages" do
    context "with valid API key" do
      let!(:messages) { create_list(:message, 3) }

      it "returns a successful response" do
        get api_v1_messages_path, headers: headers
        expect(response).to be_successful
      end

      it "returns all messages as JSON" do
        get api_v1_messages_path, headers: headers
        expect(response.content_type).to match(a_string_including("application/json"))
        json = JSON.parse(response.body)
        expect(json.length).to eq(3)
      end

      it "returns messages with correct attributes" do
        get api_v1_messages_path, headers: headers
        json = JSON.parse(response.body)
        expect(json.first.keys).to contain_exactly("id", "subject", "body", "created_at", "updated_at")
      end
    end

    context "without API key" do
      it "returns unauthorized status" do
        get api_v1_messages_path, headers: { "Accept" => "application/json" }
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        get api_v1_messages_path, headers: { "Accept" => "application/json" }
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Unauthorized")
      end
    end

    context "with invalid API key" do
      it "returns unauthorized status" do
        get api_v1_messages_path, headers: { "X-API-Key" => "invalid_key", "Accept" => "application/json" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with inactive API key" do
      let(:inactive_key) { create(:api_key, active: false) }

      it "returns unauthorized status" do
        get api_v1_messages_path, headers: { "X-API-Key" => inactive_key.token, "Accept" => "application/json" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/messages/:id" do
    let(:message) { create(:message) }

    context "with valid API key" do
      it "returns a successful response" do
        get api_v1_message_path(message), headers: headers
        expect(response).to be_successful
      end

      it "returns the message as JSON" do
        get api_v1_message_path(message), headers: headers
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(message.id)
        expect(json["subject"]).to eq(message.subject)
        expect(json["body"]).to eq(message.body)
      end
    end

    context "when message does not exist" do
      it "returns not found status" do
        get api_v1_message_path(id: 99999), headers: headers
        expect(response).to have_http_status(:not_found)
      end

      it "returns error message" do
        get api_v1_message_path(id: 99999), headers: headers
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Resource not found")
      end
    end
  end

  describe "POST /api/v1/messages" do
    context "with valid parameters and API key" do
      it "creates a new Message" do
        expect {
          post api_v1_messages_path, params: { message: valid_attributes }.to_json, headers: headers
        }.to change(Message, :count).by(1)
      end

      it "returns created status" do
        post api_v1_messages_path, params: { message: valid_attributes }.to_json, headers: headers
        expect(response).to have_http_status(:created)
      end

      it "returns the created message as JSON" do
        post api_v1_messages_path, params: { message: valid_attributes }.to_json, headers: headers
        json = JSON.parse(response.body)
        expect(json["subject"]).to eq("Test Subject")
        expect(json["body"]).to eq("Test Body")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Message" do
        expect {
          post api_v1_messages_path, params: { message: invalid_attributes }.to_json, headers: headers
        }.not_to change(Message, :count)
      end

      it "returns unprocessable_entity status" do
        post api_v1_messages_path, params: { message: invalid_attributes }.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        post api_v1_messages_path, params: { message: invalid_attributes }.to_json, headers: headers
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "PATCH /api/v1/messages/:id" do
    let(:message) { create(:message) }
    let(:new_attributes) do
      { subject: "Updated Subject", body: "Updated Body" }
    end

    context "with valid parameters and API key" do
      it "updates the requested message" do
        patch api_v1_message_path(message), params: { message: new_attributes }.to_json, headers: headers
        message.reload
        expect(message.subject).to eq("Updated Subject")
        expect(message.body).to eq("Updated Body")
      end

      it "returns success status" do
        patch api_v1_message_path(message), params: { message: new_attributes }.to_json, headers: headers
        expect(response).to be_successful
      end

      it "returns the updated message as JSON" do
        patch api_v1_message_path(message), params: { message: new_attributes }.to_json, headers: headers
        json = JSON.parse(response.body)
        expect(json["subject"]).to eq("Updated Subject")
        expect(json["body"]).to eq("Updated Body")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity status" do
        patch api_v1_message_path(message), params: { message: invalid_attributes }.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        patch api_v1_message_path(message), params: { message: invalid_attributes }.to_json, headers: headers
        json = JSON.parse(response.body)
        expect(json["errors"]).to be_present
      end
    end
  end

  describe "DELETE /api/v1/messages/:id" do
    let!(:message) { create(:message) }

    context "with valid API key" do
      it "destroys the requested message" do
        expect {
          delete api_v1_message_path(message), headers: headers
        }.to change(Message, :count).by(-1)
      end

      it "returns no_content status" do
        delete api_v1_message_path(message), headers: headers
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
