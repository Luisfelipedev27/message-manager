module Api
  module V1
    class MessagesController < BaseController
      before_action :set_message, only: [:show, :update, :destroy]

      def index
        @messages = Message.order(created_at: :desc).limit(100)
      end

      def show
      end

      def create
        @message = Message.new(message_params)

        if @message.save
          render :show, status: :created
        else
          render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @message.update(message_params)
          render :show
        else
          render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @message.destroy
        head :no_content
      end

      private

      def set_message
        @message = Message.find(params[:id])
      end

      def message_params
        params.require(:message).permit(:subject, :body)
      end
    end
  end
end
