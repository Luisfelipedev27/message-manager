require 'rails_helper'

RSpec.describe "Messages", type: :request do
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

  describe "GET /messages" do
    it "returns a successful response" do
      get messages_path
      expect(response).to be_successful
    end
  end

  describe "GET /messages/:id" do
    let(:message) { create(:message) }

    it "returns a successful response" do
      get message_path(message)
      expect(response).to be_successful
    end
  end

  describe "GET /messages/new" do
    it "returns a successful response" do
      get new_message_path
      expect(response).to be_successful
    end
  end

  describe "GET /messages/:id/edit" do
    let(:message) { create(:message) }

    it "returns a successful response" do
      get edit_message_path(message)
      expect(response).to be_successful
    end
  end

  describe "POST /messages" do
    context "with valid parameters" do
      it "creates a new Message" do
        expect {
          post messages_path, params: { message: valid_attributes }
        }.to change(Message, :count).by(1)
      end

      it "redirects to the created message" do
        post messages_path, params: { message: valid_attributes }
        expect(response).to redirect_to(Message.last)
      end

      it "sets a success notice" do
        post messages_path, params: { message: valid_attributes }
        expect(flash[:notice]).to eq("Message was successfully created.")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Message" do
        expect {
          post messages_path, params: { message: invalid_attributes }
        }.not_to change(Message, :count)
      end

      it "returns unprocessable_entity status" do
        post messages_path, params: { message: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /messages/:id" do
    let(:message) { create(:message) }
    let(:new_attributes) do
      { subject: "Updated Subject", body: "Updated Body" }
    end

    context "with valid parameters" do
      it "updates the requested message" do
        patch message_path(message), params: { message: new_attributes }
        message.reload
        expect(message.subject).to eq("Updated Subject")
        expect(message.body).to eq("Updated Body")
      end

      it "redirects to the message" do
        patch message_path(message), params: { message: new_attributes }
        expect(response).to redirect_to(message)
      end

      it "sets a success notice" do
        patch message_path(message), params: { message: new_attributes }
        expect(flash[:notice]).to eq("Message was successfully updated.")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable_entity status" do
        patch message_path(message), params: { message: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /messages/:id" do
    let!(:message) { create(:message) }

    it "destroys the requested message" do
      expect {
        delete message_path(message)
      }.to change(Message, :count).by(-1)
    end

    it "redirects to the messages list" do
      delete message_path(message)
      expect(response).to redirect_to(messages_url)
    end

    it "sets a success notice" do
      delete message_path(message)
      expect(flash[:notice]).to eq("Message was successfully deleted.")
    end
  end
end
