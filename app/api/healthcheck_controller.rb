# frozen_string_literal: true

module Api
  class HealthcheckController < ApplicationController
    skip_before_action :authenticate_request

    def index
      render json: {
        status: 'ok',
        timestamp: Time.current.iso8601,
        version: '1.0.0',
        tenant: Carva::Current.tenant&.subdomain
      }
    end
  end
end
