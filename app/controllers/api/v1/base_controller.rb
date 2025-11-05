module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_with_api_key

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

      def authenticate_with_api_key
        api_key = request.headers['X-API-Key']

        unless api_key && ApiKey.active.exists?(token: api_key)
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def not_found
        render json: { error: 'Resource not found' }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
