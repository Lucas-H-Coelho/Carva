# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Storefront::BookingsController, type: :request do
  def json_response
    ActiveSupport::JSON.decode(response.body)
  end

  describe 'POST /api/v1/storefront/bookings' do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant: tenant) }
    let(:service) { create(:service, tenant: tenant, active: true) }
    let(:scheduled_at) { 1.day.from_now }
    let(:token) do
      JWT.encode(
        { sub: user.id, iat: Time.current.to_i, exp: 7.days.from_now.to_i },
        Rails.application.secret_key_base,
        'HS256'
      )
    end

    before do
      allow(Carva::Current).to receive(:tenant).and_return(tenant)
    end

    context 'with valid params' do
      it 'creates a booking' do
        expect {
          post api_v1_storefront_bookings_url,
               headers: { 'Authorization' => "Bearer #{token}" },
               params: { service_id: service.id, scheduled_at: scheduled_at, notes: 'Chegar 10 min antes' }
        }.to change(Carva::Storefront::Booking, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response['data']['type']).to eq('carva/storefront/booking')
        expect(json_response['data']['attributes']['notes']).to eq('Chegar 10 min antes')
      end

      it 'returns 404 when service is not found' do
        post api_v1_storefront_bookings_url,
             headers: { 'Authorization' => "Bearer #{token}" },
             params: { service_id: 99999, scheduled_at: scheduled_at }

        expect(response).to have_http_status(:not_found)
        expect(json_response['errors'][0]['title']).to eq('Service not found')
      end

      it 'returns 404 when service is inactive' do
        inactive_service = create(:service, tenant: tenant, active: false)

        post api_v1_storefront_bookings_url,
             headers: { 'Authorization' => "Bearer #{token}" },
             params: { service_id: inactive_service.id, scheduled_at: scheduled_at }

        expect(response).to have_http_status(:not_found)
        expect(json_response['errors'][0]['title']).to eq('Service not found')
      end

      it 'returns 422 when booking is invalid' do
        post api_v1_storefront_bookings_url,
             headers: { 'Authorization' => "Bearer #{token}" },
             params: { service_id: service.id, scheduled_at: nil }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors'][0]['title']).to include("can't be blank")
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        post api_v1_storefront_bookings_url,
             params: { service_id: service.id, scheduled_at: scheduled_at }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/storefront/bookings' do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant: tenant) }
    let(:service) { create(:service, tenant: tenant, active: true) }
    let!(:past_booking) { create(:booking, tenant: tenant, user: user, service: service, scheduled_at: 1.day.ago, status: :pending) }
    let!(:future_booking) { create(:booking, tenant: tenant, user: user, service: service, scheduled_at: 1.day.from_now, status: :pending) }
    let(:token) do
      JWT.encode(
        { sub: user.id, iat: Time.current.to_i, exp: 7.days.from_now.to_i },
        Rails.application.secret_key_base,
        'HS256'
      )
    end

    before do
      allow(Carva::Current).to receive(:tenant).and_return(tenant)
    end

    context 'with authenticated user' do
      it 'returns bookings for the user' do
        get api_v1_storefront_bookings_url,
            headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(2)
      end

      it 'returns bookings ordered by scheduled_at desc' do
        get api_v1_storefront_bookings_url,
            headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        expect(json_response['data'].length).to eq(2)
        expect(json_response['data'][0]['id']).to eq(future_booking.id)
        expect(json_response['data'][1]['id']).to eq(past_booking.id)
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        get api_v1_storefront_bookings_url

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
