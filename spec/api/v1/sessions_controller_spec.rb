# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  # Helper to parse JSON response body
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end
  describe 'POST /api/v1/session' do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant: tenant) }
    let(:password) { 'testpassword123' }

    before do
      user.update_column(:encrypted_password, Digest::SHA256.hexdigest(password))
    end

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post api_v1_session_url,
             params: { email: user.email, password: password }

        expect(response).to have_http_status(:ok)
        expect(json_response['token']).not_to be_nil
        expect(json_response['token']).to be_a(String)
      end
    end

    context 'with invalid credentials' do
      it 'returns 401' do
        post api_v1_session_url,
             params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end

    context 'with non-existent user' do
      it 'returns 401' do
        post api_v1_session_url,
             params: { email: 'nonexistent@example.com', password: 'testpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'GET /api/v1/session/me' do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant: tenant) }
    let(:token) do
      JWT.encode(
        { sub: user.id, iat: Time.current.to_i, exp: 7.days.from_now.to_i },
        Rails.application.secret_key_base,
        'HS256'
      )
    end

    context 'with valid token' do
      it 'returns user info' do
        get me_api_v1_session_url, headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        expect(json_response['user']['id']).to eq(user.id)
        expect(json_response['user']['email']).to eq(user.email)
        expect(json_response['user']['role']).to eq(user.role)
        expect(json_response['user']['tenant']).to eq(tenant.subdomain)
      end
    end

    context 'without token' do
      it 'returns 401' do
        get me_api_v1_session_url

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Not authenticated')
      end
    end
  end

  describe 'DELETE /api/v1/session' do
    it 'returns 204' do
      delete api_v1_session_url

      expect(response).to have_http_status(:no_content)
    end
  end
end
