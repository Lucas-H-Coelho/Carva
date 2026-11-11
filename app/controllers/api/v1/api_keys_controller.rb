# frozen_string_literal: true

module Api
  module V1
    class ApiKeysController < ApplicationController
      skip_before_action :authenticate_request, raise: false

      before_action :require_owner

      def show
        render json: {
          data: {
            id: current_user.id,
            type: 'api_key',
            attributes: { api_key: current_user.api_key }
          },
          meta: { version: 'v1' }
        }, status: :ok
      end

      def regenerate
        current_user.update_column(:api_key, SecureRandom.uuid)
        render json: {
          data: {
            id: current_user.id,
            type: 'api_key',
            attributes: { api_key: current_user.api_key }
          },
          meta: { version: 'v1' }
        }, status: :ok
      end
    end
  end
end
