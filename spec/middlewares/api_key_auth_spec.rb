# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiKeyAuth, type: :middleware do
  let(:app) { ->(_env) { [200, {}, ['OK']] } }
  let(:middleware) { described_class.new(app) }
  let(:tenant) { create(:tenant, :active) }
  let(:user) { create(:user, tenant: tenant) }

  describe '#call' do
    context 'with valid X-Carva-API-Key header' do
      let(:env) { valid_env(user.api_key) }

      it 'injects current_user and current_tenant into env' do
        middleware.call(env)
        expect(env['current_user']).to eq(user)
        expect(env['current_tenant']).to eq(tenant)
      end

      it 'returns 200 from the downstream app' do
        status, _headers, _body = middleware.call(env)
        expect(status).to eq(200)
      end
    end

    context 'with invalid API key' do
      let(:env) { valid_env('invalid-key-12345') }

      it 'does not inject current_user' do
        middleware.call(env)
        expect(env['current_user']).to be_nil
      end

      it 'does not inject current_tenant' do
        middleware.call(env)
        expect(env['current_tenant']).to be_nil
      end

      it 'returns 200 from the downstream app' do
        status, _headers, _body = middleware.call(env)
        expect(status).to eq(200)
      end
    end

    context 'with no API key header' do
      let(:env) { valid_env(nil) }

      it 'does not inject current_user' do
        middleware.call(env)
        expect(env['current_user']).to be_nil
      end

      it 'returns 200 from the downstream app' do
        status, _headers, _body = middleware.call(env)
        expect(status).to eq(200)
      end
    end

    context 'with inactive tenant' do
      let(:suspended_tenant) { create(:tenant, :suspended) }
      let(:suspended_user) { create(:user, tenant: suspended_tenant) }
      let(:env) { valid_env(suspended_user.api_key) }

      it 'does not inject current_user' do
        middleware.call(env)
        expect(env['current_user']).to be_nil
      end
    end
  end

  def valid_env(api_key)
    {
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/api/v1/test',
      'HTTP_X_CARVA_API_KEY' => api_key
    }
  end
end
