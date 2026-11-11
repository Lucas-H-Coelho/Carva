# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarvaInventory::CreateService, type: :service do
  describe '#call' do
    let(:tenant) { create(:tenant, :active) }

    context 'with valid params' do
      it 'creates a service' do
        result = described_class.call(
          tenant: tenant,
          name: 'Lavagem Completa',
          slug: 'lavagem-completa',
          description: 'Servico de lavagem',
          duration_minutes: 30,
          price_cents: 5000,
          category: 'basic',
          active: true
        )

        expect(result).to be_a(ApplicationService::SuccessResult)
        expect(result.data).to be_a(Carva::Inventory::Service)
        expect(result.data.name).to eq('Lavagem Completa')
        expect(result.data.tenant).to eq(tenant)
      end

      it 'defaults duration_minutes to 30' do
        result = described_class.call(
          tenant: tenant,
          name: 'Lavagem',
          slug: 'lavagem'
        )

        expect(result).to be_a(ApplicationService::SuccessResult)
        expect(result.data.duration_minutes).to eq(30)
      end

      it 'defaults price_cents to 0' do
        result = described_class.call(
          tenant: tenant,
          name: 'Lavagem',
          slug: 'lavagem'
        )

        expect(result).to be_a(ApplicationService::SuccessResult)
        expect(result.data.price_cents).to eq(0)
      end
    end

    context 'without tenant' do
      it 'returns failure' do
        result = described_class.call(
          name: 'Lavagem',
          slug: 'lavagem'
        )

        expect(result).to be_a(ApplicationService::FailureResult)
        expect(result.errors).to include('Tenant is required')
      end
    end

    context 'with invalid params' do
      it 'returns validation errors' do
        result = described_class.call(
          tenant: tenant,
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
