# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:controller_class) { HealthcheckController }
  let(:tenant) { create(:tenant) }
  let(:user) { create(:user, tenant: tenant) }

  describe '#authenticate_request' do
    context 'when Authorization header is missing' do
      it 'calls render_json_error with Unauthorized' do
        allow(controller).to receive(:render_json_error)
        controller.send(:authenticate_request)
        expect(controller).to have_received(:render_json_error).with('Unauthorized', 401)
      end
    end

    context 'when token is invalid' do
      before do
        request.headers['Authorization'] = 'Bearer invalid_token'
      end

      it 'calls render_json_error with Unauthorized' do
        allow(controller).to receive(:render_json_error)
        controller.send(:authenticate_request)
        expect(controller).to have_received(:render_json_error).with('Unauthorized', 401)
      end
    end

    context 'when token is expired' do
      let(:token) do
        JWT.encode(
          { sub: user.id, exp: Time.now.to_i - 3600 },
          Rails.application.secret_key_base,
          'HS256'
        )
      end

      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'calls render_json_error with Unauthorized' do
        allow(controller).to receive(:render_json_error)
        controller.send(:authenticate_request)
        expect(controller).to have_received(:render_json_error).with('Unauthorized', 401)
      end
    end

    context 'when tenant is suspended' do
      let(:suspended_tenant) { create(:tenant, status: :suspended) }
      let(:suspended_user) { create(:user, tenant: suspended_tenant) }
      let(:token) do
        JWT.encode(
          { sub: suspended_user.id },
          Rails.application.secret_key_base,
          'HS256'
        )
      end

      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'calls render_json_error with Forbidden' do
        allow(controller).to receive(:render_json_error)
        controller.send(:authenticate_request)
        expect(controller).to have_received(:render_json_error).with('Forbidden', 403)
      end
    end

    context 'when token is valid and tenant is active' do
      let(:active_tenant) { create(:tenant, :active) }
      let(:active_user) { create(:user, tenant: active_tenant) }
      let(:token) do
        JWT.encode(
          { sub: active_user.id },
          Rails.application.secret_key_base,
          'HS256'
        )
      end

      before do
        request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'sets @current_user' do
        controller.send(:authenticate_request)
        expect(controller.instance_variable_get(:@current_user)).to eq(active_user)
      end
    end
  end

  describe '#current_user' do
    it 'returns @current_user' do
      expect(controller.send(:current_user)).to be_nil
    end
  end

  describe '#render_json_error' do
    it 'renders JSON:API error with pointer' do
      allow(controller).to receive(:render)
      controller.send(:render_json_error, 'Not Found', 404, detail: 'Resource not found', pointer: '/data')
      expect(controller).to have_received(:render).with(
        json: {
          errors: [{
            status: 404,
            title: 'Not Found',
            detail: 'Resource not found',
            source: { pointer: '/data' }
          }]
        },
        status: 404
      )
    end

    it 'renders JSON:API error without pointer' do
      allow(controller).to receive(:render)
      controller.send(:render_json_error, 'Bad Request', 400)
      expect(controller).to have_received(:render).with(
        json: {
          errors: [{
            status: 400,
            title: 'Bad Request',
            detail: 'Bad Request'
          }]
        },
        status: 400
      )
    end
  end

  describe '#render_json_api' do
    let(:service) { Carva::Inventory::Service.new(id: 1, name: 'Wash', slug: 'wash', duration_minutes: 30, price_cents: 5000, tenant: tenant) }

    it 'renders JSON:API resource format' do
      allow(controller).to receive(:render)
      controller.send(:render_json_api, service)
      expect(controller).to have_received(:render).with(
        json: {
          data: {
            id: service.id,
            type: 'carva/inventory/service',
            attributes: service.as_json(except: %i[created_at updated_at])
          },
          meta: { version: 'v1' }
        },
        status: :ok
      )
    end

    it 'renders with custom status' do
      allow(controller).to receive(:render)
      controller.send(:render_json_api, service, status: :created)
      expect(controller).to have_received(:render).with(
        json: {
          data: {
            id: service.id,
            type: 'carva/inventory/service',
            attributes: service.as_json(except: %i[created_at updated_at])
          },
          meta: { version: 'v1' }
        },
        status: :created
      )
    end
  end

  describe '#render_json_api_collection' do
    let(:services) do
      [
        Carva::Inventory::Service.new(id: 1, name: 'Wash', slug: 'wash', duration_minutes: 30, price_cents: 5000, tenant: tenant),
        Carva::Inventory::Service.new(id: 2, name: 'Detail', slug: 'detail', duration_minutes: 60, price_cents: 10000, tenant: tenant),
        Carva::Inventory::Service.new(id: 3, name: 'Full', slug: 'full', duration_minutes: 90, price_cents: 15000, tenant: tenant)
      ]
    end

    it 'renders JSON:API collection format' do
      allow(controller).to receive(:render)
      controller.params = { page: '1', per_page: '25' }
      controller.send(:render_json_api_collection, services)
      expect(controller).to have_received(:render).with(
        json: {
          data: services.map { |s| {
            id: s.id,
            type: 'carva/inventory/service',
            attributes: s.as_json(except: %i[created_at updated_at])
          }},
          meta: {
            version: 'v1',
            page: {
              current: '1',
              total: 1,
              per_page: '25'
            }
          }
        },
        status: :ok
      )
    end
  end

  describe '#serialize_resource' do
    let(:service) { Carva::Inventory::Service.new(id: 1, name: 'Wash', slug: 'wash', duration_minutes: 30, price_cents: 5000, tenant: tenant) }

    it 'returns resource with id, type, and attributes' do
      result = controller.send(:serialize_resource, service)
      expect(result[:id]).to eq(service.id)
      expect(result[:type]).to eq('carva/inventory/service')
      expect(result[:attributes]).to be_a(Hash)
    end
  end
end
