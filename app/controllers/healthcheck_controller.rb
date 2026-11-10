# frozen_string_literal: true

class HealthcheckController < ApplicationController
  # TODO: add skip_before_action :authenticate_request once Devise is configured

  def index
    render json: { status: 'ok', timestamp: Time.now.iso8601 }, status: :ok
  end
end
