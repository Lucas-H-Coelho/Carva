# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ApiKeysController, type: :request do
  let(:tenant) { create(:tenant, :active) }
  let(:owner) { create(:user, :owner, tenant: tenant) }
  let(:headers) { { 'X-Carva-API-Key' => owner.api_key } }

  describe 'GET #show' do
    it 'returns the user API key' do
      get api_v1_api_key_show_path, headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['id']).to eq(owner.id)
      expect(json['data']['attributes']['api_key']).to eq(owner.api_key)
    end

    it 'returns 401 without API key' do
      get api_v1_api_key_show_path, headers: {}

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #regenerate' do
    it 'regenerates the API key' do
      old_key = owner.api_key
      expect(old_key).not_to be_nil

      delete api_v1_api_key_regenerate_path, headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['api_key']).not_to eq(old_key)
      expect(owner.reload.api_key).not_to eq(old_key)
    end
  end
end
