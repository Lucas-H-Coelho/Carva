# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarvaInventory::ServiceForm, type: :form do
  let(:tenant) { create(:tenant, :active) }
  let(:service) { create(:service, tenant: tenant) }

  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        form = described_class.new(
          name: 'Lavagem Completa',
          slug: 'lavagem-completa',
          description: 'Description',
          duration_minutes: 30,
          price_cents: 5000,
          category: 'basic',
          active: true
        )

        expect(form).to be_valid
      end
    end

    context 'with blank name' do
      it 'is invalid' do
        form = described_class.new(name: '', slug: 'test')
        expect(form).not_to be_valid
        expect(form.errors[:name]).to include("can't be blank")
      end
    end

    context 'with name too long' do
      it 'is invalid' do
        form = described_class.new(name: 'a' * 256, slug: 'test')
        expect(form).not_to be_valid
        expect(form.errors[:name]).to include('is too long (maximum is 255 characters)')
      end
    end

    context 'with blank slug' do
      it 'is valid — the model generates slug from name' do
        form = described_class.new(name: 'Test Service', slug: '')
        expect(form).to be_valid
      end
    end

    context 'with invalid duration_minutes' do
      it 'is invalid when zero' do
        form = described_class.new(name: 'Test', slug: 'test', duration_minutes: 0)
        expect(form).not_to be_valid
        expect(form.errors[:duration_minutes]).to include('must be greater than 0')
      end

      it 'is invalid when negative' do
        form = described_class.new(name: 'Test', slug: 'test', duration_minutes: -5)
        expect(form).not_to be_valid
        expect(form.errors[:duration_minutes]).to include('must be greater than 0')
      end

      it 'is valid when nil' do
        form = described_class.new(name: 'Test', slug: 'test', duration_minutes: nil)
        expect(form).to be_valid
      end
    end

    context 'with negative price_cents' do
      it 'is invalid' do
        form = described_class.new(name: 'Test', slug: 'test', price_cents: -100)
        expect(form).not_to be_valid
        expect(form.errors[:price_cents]).to include('must be greater than or equal to 0')
      end

      it 'is valid when nil' do
        form = described_class.new(name: 'Test', slug: 'test', price_cents: nil)
        expect(form).to be_valid
      end
    end

    context 'with description too long' do
      it 'is invalid' do
        form = described_class.new(name: 'Test', slug: 'test', description: 'a' * 2001)
        expect(form).not_to be_valid
        expect(form.errors[:description]).to include('is too long (maximum is 2000 characters)')
      end
    end
  end

  describe '#persist' do
    context 'with valid form' do
      it 'updates the service' do
        form = described_class.new(
          name: 'Updated Service',
          slug: 'updated-service',
          description: 'New desc',
          duration_minutes: 60,
          price_cents: 10000,
          category: 'premium',
          active: false
        )

        result = form.persist(service)
        expect(result).to be true
        expect(service.name).to eq('Updated Service')
        expect(service.duration_minutes).to eq(60)
        expect(service.price_cents).to eq(10000)
        expect(service.active).to be false
      end
    end

    context 'with invalid form' do
      it 'does not persist' do
        form = described_class.new(name: '', slug: '')
        result = form.persist(service)
        expect(result).to be false
      end
    end
  end

  describe '#to_model' do
    it 'returns self' do
      form = described_class.new(name: 'Test', slug: 'test')
      expect(form.to_model).to eq(form)
    end
  end

  describe '#to_partial_path' do
    it 'returns the partial path' do
      form = described_class.new(name: 'Test', slug: 'test')
      expect(form.to_partial_path).to eq('carva_inventory/service_forms/service_form')
    end
  end

  describe '#model_name' do
    it 'returns an ActiveModel::Name' do
      form = described_class.new(name: 'Test', slug: 'test')
      expect(form.model_name).to be_a(ActiveModel::Name)
    end
  end
end
