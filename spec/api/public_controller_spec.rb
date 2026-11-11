# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PublicController, type: :request do
  let(:tenant) { create(:tenant, :active) }

  describe 'GET #health' do
    it 'returns 200 with status ok' do
      get api_v1_public_health_path

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('ok')
      expect(json['version']).to eq('v1')
      expect(json['timestamp']).not_to be_nil
    end
  end

  describe 'GET #services' do
    context 'with no services' do
      it 'returns empty collection' do
        get api_v1_public_services_path

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data']).to eq([])
      end
    end
  end

  describe 'GET #available_slots' do
    context 'with no services' do
      it 'returns empty slots' do
        get api_v1_public_available_slots_path

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data']).to eq([])
      end
    end
  end

  it 'does not require authentication' do
    get api_v1_public_health_path, headers: {}
    expect(response).to have_http_status(:ok)
  end
end
