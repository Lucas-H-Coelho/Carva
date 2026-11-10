# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carva::Inventory::Product, type: :model do
  describe 'associations' do
    let(:tenant) { create(:tenant) }
    let(:product) { build(:product, tenant: tenant) }

    it { expect(product).to respond_to(:tenant) }
    it { expect(product).to respond_to(:line_items) }
  end

  describe 'validations' do
    let(:tenant) { create(:tenant) }

    context 'when name is blank' do
      subject { build(:product, tenant: tenant, name: nil) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include("can't be blank")
      end
    end

    context 'when name is too long' do
      subject { build(:product, tenant: tenant, name: 'a' * 256) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:name]).to include('is too long (maximum is 255 characters)')
      end
    end

    context 'when slug is blank' do
      subject { build(:product, tenant: tenant, slug: nil) }

      it 'generates a slug from name before validation' do
        expect(subject).to be_valid
        expect(subject.slug).not_to be_blank
      end
    end

    context 'when price_cents is negative' do
      subject { build(:product, tenant: tenant, price_cents: -100) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:price_cents]).to include('must be greater than or equal to 0')
      end
    end

    context 'when stock_quantity is negative' do
      subject { build(:product, tenant: tenant, stock_quantity: -5) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:stock_quantity]).to include('must be greater than or equal to 0')
      end
    end

    context 'when stock_quantity is a float' do
      subject { build(:product, tenant: tenant, stock_quantity: 5.5) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:stock_quantity]).to include('must be an integer')
      end
    end
  end

  describe 'slug generation' do
    let(:tenant) { create(:tenant) }

    context 'when slug is blank and name is present' do
      subject { build(:product, tenant: tenant, name: 'Shampoo Premium', slug: nil) }

      it 'generates a slug from the name' do
        expect(subject).to be_valid
        expect(subject.slug).to eq('shampoo-premium')
      end
    end

    context 'when slug is already set' do
      subject { build(:product, tenant: tenant, name: 'Shampoo Premium', slug: 'shampoo-premium-v2') }

      it 'does not overwrite the slug' do
        expect(subject).to be_valid
        expect(subject.slug).to eq('shampoo-premium-v2')
      end
    end
  end

  describe '#in_stock?' do
    let(:tenant) { create(:tenant) }

    context 'when stock_quantity is greater than 0' do
      subject { create(:product, tenant: tenant, stock_quantity: 10) }

      it 'returns true' do
        expect(subject.in_stock?).to be true
      end
    end

    context 'when stock_quantity is 0' do
      subject { create(:product, tenant: tenant, stock_quantity: 0) }

      it 'returns false' do
        expect(subject.in_stock?).to be false
      end
    end
  end
end
