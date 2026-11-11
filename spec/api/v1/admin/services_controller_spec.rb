# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ServicesController, type: :request do
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  let(:tenant) { create(:tenant, :active) }
  let(:owner) { create(:user, :owner, tenant: tenant) }
  let(:shift_lead) { create(:user, :shift_lead, tenant: tenant) }
  let(:service) { create(:service, tenant: tenant) }

  # Helper to build auth headers
  def auth_headers(user)
    token = JWT.encode(
      { sub: user.id, iat: Time.current.to_i, exp: 7.days.from_now.to_i },
      Rails.application.secret_key_base,
      'HS256'
    )
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/admin/services' do
    context 'with owner' do
      it 'returns services list' do
        service # create up front, fora do bloco de asserções
        get api_v1_services_url, headers: auth_headers(owner)
        expect(response).to have_http_status(:ok)
        data = json_response['data']
        expect(data).to be_an(Array)
        expect(data.length).to be >= 1
        expect(data.first['type']).to eq('carva/inventory/service')
      end
    end

    context 'with shift_lead' do
      it 'returns services list' do
        get api_v1_services_url, headers: auth_headers(shift_lead)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without auth' do
      it 'returns 401' do
        get api_v1_services_url
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/admin/services/:id' do
    context 'with owner' do
      it 'returns the service' do
        get api_v1_service_url(service), headers: auth_headers(owner)
        expect(response).to have_http_status(:ok)
        data = json_response['data']
        expect(data['id']).to eq(service.id)
        expect(data['type']).to eq('carva/inventory/service')
      end
    end

    context 'with shift_lead' do
      it 'returns the service' do
        get api_v1_service_url(service), headers: auth_headers(shift_lead)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without auth' do
      it 'returns 401' do
        get api_v1_service_url(service)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/admin/services' do
    context 'with owner' do
      it 'creates a service' do
        expect {
          post api_v1_services_url,
               params: { name: 'Lavagem Premium', slug: 'lavagem-premium', description: 'Servico premium', duration_minutes: 60, price_cents: 10000, category: 'premium', active: true }.to_json,
               headers: auth_headers(owner).merge('CONTENT_TYPE' => 'application/json')
        }.to change(Carva::Inventory::Service, :count).by(1)

        expect(response).to have_http_status(:created)
        data = json_response['data']
        expect(data['attributes']['name']).to eq('Lavagem Premium')
      end

      it 'returns 422 on invalid params' do
        post api_v1_services_url,
             params: { name: '', slug: '', duration_minutes: -5 },
             headers: auth_headers(owner)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without auth' do
      it 'returns 401' do
        post api_v1_services_url,
             params: { name: 'Test' },
             headers: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/admin/services/:id' do
    context 'with owner' do
      it 'updates the service' do
        patch api_v1_service_url(service),
              params: { name: 'Updated Name', duration_minutes: 45 },
              headers: auth_headers(owner)

        expect(response).to have_http_status(:ok)
        data = json_response['data']
        expect(data['attributes']['name']).to eq('Updated Name')
        expect(data['attributes']['duration_minutes']).to eq(45)
      end
    end

    context 'with shift_lead' do
      it 'updates the service' do
        patch api_v1_service_url(service),
              params: { name: 'Shift Updated' },
              headers: auth_headers(shift_lead)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'without auth' do
      it 'returns 401' do
        patch api_v1_service_url(service),
              params: { name: 'Hacked' },
              headers: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/admin/services/:id' do
    context 'with owner' do
      it 'deletes the service' do
        service # create up front, fora do bloco expect
        expect {
          delete api_v1_service_url(service), headers: auth_headers(owner)
        }.to change(Carva::Inventory::Service, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'without auth' do
      it 'returns 401' do
        delete api_v1_service_url(service), headers: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/admin/services/:id/toggle_active' do
    context 'with owner' do
      it 'toggles active status' do
        expect {
          post toggle_active_api_v1_service_url(service), headers: auth_headers(owner)
        }.to change { service.reload.active }.from(true).to(false)

        expect(response).to have_http_status(:ok)
        data = json_response['data']
        expect(data['attributes']['active']).to be false
      end
    end

    context 'without auth' do
      it 'returns 401' do
        post toggle_active_api_v1_service_url(service), headers: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
