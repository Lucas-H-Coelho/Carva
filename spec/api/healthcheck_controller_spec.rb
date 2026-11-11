# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::HealthcheckController, type: :request do
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  describe 'GET #index' do
    it 'returns status ok' do
      get '/healthcheck'

      expect(response).to have_http_status(:ok)
      expect(json_response['status']).to eq('ok')
      expect(json_response['timestamp']).not_to be_nil
      expect(json_response['version']).to eq('1.0.0')
    end

    it 'returns nil tenant when Carva::Current.tenant is not set' do
      get '/healthcheck'

      expect(response).to have_http_status(:ok)
      expect(json_response['tenant']).to be_nil
    end

    it 'skips authentication — no Authorization header needed' do
      get '/healthcheck', headers: {}

      expect(response).to have_http_status(:ok)
      expect(json_response['status']).to eq('ok')
    end
  end
end
