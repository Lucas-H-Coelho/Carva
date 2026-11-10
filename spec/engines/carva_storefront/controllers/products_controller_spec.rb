# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Storefront::ProductsController, type: :request do
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  describe 'GET /api/v1/storefront/products' do
    let(:tenant) { create(:tenant) }
    let!(:active_product) { create(:product, tenant: tenant, active: true, name: 'Shampoo Auto', slug: 'shampoo-auto') }
    let!(:inactive_product) { create(:product, tenant: tenant, active: false, name: 'Shampoo Velho', slug: 'shampoo-velho') }
    let(:other_tenant) { create(:tenant, subdomain: 'outrolava') }
    let!(:other_tenant_product) { create(:product, tenant: other_tenant, active: true, name: 'Outro Produto', slug: 'outro-produto') }

    before do
      allow(Carva::Current).to receive(:tenant).and_return(tenant)
    end

    context 'with active products' do
      it 'returns only active products for the tenant' do
        get api_v1_storefront_products_url

        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(1)
        expect(json_response['data'][0]['id']).to eq(active_product.id)
        expect(json_response['data'][0]['type']).to eq('carva/inventory/product')
      end

      it 'excludes inactive products' do
        get api_v1_storefront_products_url

        expect(response).to have_http_status(:ok)
        ids = json_response['data'].map { |d| d['id'] }
        expect(ids).not_to include(inactive_product.id)
      end

      it 'excludes products from other tenants' do
        get api_v1_storefront_products_url

        expect(response).to have_http_status(:ok)
        ids = json_response['data'].map { |d| d['id'] }
        expect(ids).not_to include(other_tenant_product.id)
      end

      it 'includes meta with version' do
        get api_v1_storefront_products_url

        expect(response).to have_http_status(:ok)
        expect(json_response['meta']['version']).to eq('v1')
      end
    end

    context 'when tenant is not found' do
      before do
        allow(Carva::Current).to receive(:tenant).and_return(nil)
      end

      it 'returns 404' do
        get api_v1_storefront_products_url

        expect(response).to have_http_status(:not_found)
        expect(json_response['errors'][0]['title']).to eq('Tenant not found')
      end
    end
  end
end
