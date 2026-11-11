# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarvaInventory::UpdateService, type: :service do
  describe '#call' do
    let(:tenant) { create(:tenant, :active) }
    let(:service) { create(:service, tenant: tenant) }

    context 'with valid params' do
      it 'updates the service' do
        result = described_class.call(
          service.id,
          name: 'Updated Service',
          slug: 'updated-service',
          description: 'New description',
          duration_minutes: 60,
          price_cents: 10000,
          category: 'premium',
          active: false
        )

        expect(result).to be_a(ApplicationService::SuccessResult)
        expect(result.data.name).to eq('Updated Service')
        expect(result.data.duration_minutes).to eq(60)
        expect(result.data.price_cents).to eq(10000)
        expect(result.data.active).to be false
      end
    end

    context 'with non-existent service' do
      it 'returns failure' do
        result = described_class.call(
          99999,
          name: 'Non-existent'
        )

        expect(result).to be_a(ApplicationService::FailureResult)
        expect(result.errors).to include('Service not found')
      end
    end

    context 'with invalid params' do
      it 'returns validation errors' do
        result = described_class.call(
          service.id,
          name: '',
          slug: '',
          duration_minutes: -5
        )

        expect(result).to be_a(ApplicationService::FailureResult)
        expect(result.errors).to be_an(Array)
        expect(result.errors.length).to be > 0
      end
    end
  end
end
