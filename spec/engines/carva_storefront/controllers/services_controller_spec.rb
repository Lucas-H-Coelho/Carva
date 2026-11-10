# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Storefront::ServicesController, type: :request do
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  describe 'GET /api/v1/storefront/services' do
    let(:tenant) { create(:tenant) }
    let!(:active_service) { create(:service, tenant: tenant, active: true, name: 'Lavagem Completa', category: 'externo', slug: 'lavagem-completa') }
    let!(:inactive_service) { create(:service, tenant: tenant, active: false, name: 'Lavagem Antiga', category: 'externo', slug: 'lavagem-antiga') }
    let(:other_tenant) { create(:tenant, subdomain: 'outrolava') }
    let!(:other_tenant_service) { create(:service, tenant: other_tenant, active: true, name: 'Outro Tenant', category: 'interno', slug: 'outro-tenant') }

    before do
      allow(Carva::Current).to receive(:tenant).and_return(tenant)
    end

    context 'with active services' do
      it 'returns only active services for the tenant' do
        get api_v1_storefront_services_url

        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(1)
        expect(json_response['data'][0]['id']).to eq(active_service.id)
        expect(json_response['data'][0]['type']).to eq('carva/inventory/service')
      end

      it 'excludes inactive services' do
        get api_v1_storefront_services_url

        expect(response).to have_http_status(:ok)
        ids = json_response['data'].map { |d| d['id'] }
        expect(ids).not_to include(inactive_service.id)
      end

      it 'excludes services from other tenants' do
        get api_v1_storefront_services_url

        expect(response).to have_http_status(:ok)
        ids = json_response['data'].map { |d| d['id'] }
        expect(ids).not_to include(other_tenant_service.id)
      end

      it 'includes meta with version' do
        get api_v1_storefront_services_url

        expect(response).to have_http_status(:ok)
        expect(json_response['meta']['version']).to eq('v1')
      end
    end

    context 'when tenant is not found' do
      before do
        allow(Carva::Current).to receive(:tenant).and_return(nil)
      end

      it 'returns 404' do
        get api_v1_storefront_services_url

        expect(response).to have_http_status(:not_found)
        expect(json_response['errors'][0]['title']).to eq('Tenant not found')
      end
    end
  end
end
