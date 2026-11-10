# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carva::Inventory::Service, type: :model do
  describe 'associations' do
    let(:tenant) { create(:tenant) }
    let(:service) { build(:service, tenant: tenant) }

    it { expect(service).to respond_to(:tenant) }
    it { expect(service).to respond_to(:bookings) }
  end

  describe 'validations' do
    let(:tenant) { create(:tenant) }

    context 'when name is blank' do
      subject { build(:service, tenant: tenant, name: nil) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include("can't be blank")
      end
    end

    context 'when name is too long' do
      subject { build(:service, tenant: tenant, name: 'a' * 256) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include('is too long (maximum is 255 characters)')
      end
    end

    context 'when slug is blank' do
      subject { build(:service, tenant: tenant, slug: nil) }

      it 'generates a slug from name before validation' do
        expect(subject).to be_valid
        expect(subject.slug).not_to be_blank
      end
    end

    context 'when duration_minutes is zero' do
      subject { build(:service, tenant: tenant, duration_minutes: 0) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:duration_minutes]).to include('must be greater than 0')
      end
    end

    context 'when duration_minutes is negative' do
      subject { build(:service, tenant: tenant, duration_minutes: -5) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:duration_minutes]).to include('must be greater than 0')
      end
    end

    context 'when price_cents is negative' do
      subject { build(:service, tenant: tenant, price_cents: -100) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:price_cents]).to include('must be greater than or equal to 0')
      end
    end
  end

  describe 'slug generation' do
    let(:tenant) { create(:tenant) }

    context 'when slug is blank and name is present' do
      subject { build(:service, tenant: tenant, name: 'Lavagem Completa', slug: nil) }

      it 'generates a slug from the name' do
        expect(subject).to be_valid
        expect(subject.slug).to eq('lavagem-completa')
      end
    end

    context 'when slug is already set' do
      subject { build(:service, tenant: tenant, name: 'Lavagem Completa', slug: 'custom-slug') }

      it 'does not overwrite the slug' do
        expect(subject).to be_valid
        expect(subject.slug).to eq('custom-slug')
      end
    end
  end

  describe '#active?' do
    let(:tenant) { create(:tenant) }

    context 'when active is true' do
      subject { create(:service, tenant: tenant, active: true) }

      it 'returns true' do
        expect(subject.active?).to be true
      end
    end

    context 'when active is false' do
      subject { create(:service, tenant: tenant, active: false) }

      it 'returns false' do
        expect(subject.active?).to be false
      end
    end
  end
end
