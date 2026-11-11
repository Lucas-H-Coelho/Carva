# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarvaInventory::DeleteService, type: :service do
  describe '#call' do
    let(:tenant) { create(:tenant, :active) }
    let(:service) { create(:service, tenant: tenant) }

    context 'with existing service' do
      it 'deletes the service' do
        service # create up front, fora do bloco expect
        expect {
          described_class.call(service.id)
        }.to change(Carva::Inventory::Service, :count).by(-1)
      end

      it 'returns success result' do
        result = described_class.call(service.id)

        expect(result).to be_a(ApplicationService::SuccessResult)
        expect(result.data.id).to eq(service.id)
      end
    end

    context 'with non-existent service' do
      it 'returns failure' do
        result = described_class.call(99999)

        expect(result).to be_a(ApplicationService::FailureResult)
        expect(result.errors).to include('Service not found')
      end
    end
  end
end
