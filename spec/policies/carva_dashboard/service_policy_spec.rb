# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarvaDashboard::ServicePolicy, type: :policy do
  let(:tenant) { create(:tenant, :active) }
  let(:service) { create(:service, tenant: tenant) }

  describe '#index?' do
    context 'with authenticated user' do
      it 'returns true' do
        policy = described_class.new(create(:user, tenant: tenant), Carva::Inventory::Service)
        expect(policy.index?).to be true
      end
    end

    context 'without user' do
      it 'returns false' do
        policy = described_class.new(nil, Carva::Inventory::Service)
        expect(policy.index?).to be false
      end
    end
  end

  describe '#show?' do
    context 'with authenticated user' do
      it 'returns true' do
        policy = described_class.new(create(:user, tenant: tenant), service)
        expect(policy.show?).to be true
      end
    end

    context 'without user' do
      it 'returns false' do
        policy = described_class.new(nil, service)
        expect(policy.show?).to be false
      end
    end
  end

  describe '#create?' do
    context 'with authenticated user' do
      it 'returns true' do
        policy = described_class.new(create(:user, tenant: tenant), Carva::Inventory::Service)
        expect(policy.create?).to be true
      end
    end

    context 'without user' do
      it 'returns false' do
        policy = described_class.new(nil, Carva::Inventory::Service)
        expect(policy.create?).to be false
      end
    end
  end

  describe '#update?' do
    context 'with owner' do
      it 'returns true' do
        owner = create(:user, :owner, tenant: tenant)
        policy = described_class.new(owner, service)
        expect(policy.update?).to be true
      end
    end

    context 'with shift_lead' do
      it 'returns true' do
        shift_lead = create(:user, :shift_lead, tenant: tenant)
        policy = described_class.new(shift_lead, service)
        expect(policy.update?).to be true
      end
    end

    context 'without user' do
      it 'returns false' do
        policy = described_class.new(nil, service)
        expect(policy.update?).to be false
      end
    end
  end

  describe '#destroy?' do
    context 'with owner' do
      it 'returns true' do
        owner = create(:user, :owner, tenant: tenant)
        policy = described_class.new(owner, service)
        expect(policy.destroy?).to be true
      end
    end

    context 'with shift_lead' do
      it 'returns false' do
        shift_lead = create(:user, :shift_lead, tenant: tenant)
        policy = described_class.new(shift_lead, service)
        expect(policy.destroy?).to be false
      end
    end

    context 'without user' do
      it 'returns false' do
        policy = described_class.new(nil, service)
        expect(policy.destroy?).to be false
      end
    end
  end

  describe '#toggle_active?' do
    context 'with owner' do
      it 'returns true' do
        owner = create(:user, :owner, tenant: tenant)
        policy = described_class.new(owner, service)
        expect(policy.toggle_active?).to be true
      end
    end

    context 'with shift_lead' do
      it 'returns false' do
        shift_lead = create(:user, :shift_lead, tenant: tenant)
        policy = described_class.new(shift_lead, service)
        expect(policy.toggle_active?).to be false
      end
    end

    context 'without user' do
      it 'returns false' do
        policy = described_class.new(nil, service)
        expect(policy.toggle_active?).to be false
      end
    end
  end
end
