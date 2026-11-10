# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carva::Storefront::Booking, type: :model do
  describe 'associations' do
    let(:tenant) { create(:tenant) }
    let(:booking) { build(:booking, tenant: tenant) }

    it { expect(booking).to respond_to(:tenant) }
    it { expect(booking).to respond_to(:user) }
    it { expect(booking).to respond_to(:service) }
  end

  describe 'validations' do
    let(:tenant) { create(:tenant) }
    let(:service) { create(:service, tenant: tenant) }

    context 'when scheduled_at is blank' do
      subject { build(:booking, tenant: tenant, service: service, scheduled_at: nil) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:scheduled_at]).to include("can't be blank")
      end
    end

    context 'when status is blank' do
      subject { build(:booking, tenant: tenant, service: service, scheduled_at: Time.current, status: nil) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:status]).to include("can't be blank")
      end
    end
  end

  describe 'enum' do
    it 'has the correct status values' do
      expect(described_class.statuses).to eq(
        'pending' => 'pending',
        'confirmed' => 'confirmed',
        'completed' => 'completed',
        'cancelled' => 'cancelled'
      )
    end

    context 'when status is pending' do
      let(:tenant) { create(:tenant) }
      let(:service) { create(:service, tenant: tenant) }
      let(:booking) { create(:booking, tenant: tenant, service: service, status: :pending) }

      it 'has the correct status' do
        expect(booking.status).to eq('pending')
      end
    end

    context 'when status is confirmed' do
      let(:tenant) { create(:tenant) }
      let(:service) { create(:service, tenant: tenant) }
      let(:booking) { create(:booking, tenant: tenant, service: service, status: :confirmed) }

      it 'has the correct status' do
        expect(booking.status).to eq('confirmed')
      end
    end

    context 'when status is completed' do
      let(:tenant) { create(:tenant) }
      let(:service) { create(:service, tenant: tenant) }
      let(:booking) { create(:booking, tenant: tenant, service: service, status: :completed) }

      it 'has the correct status' do
        expect(booking.status).to eq('completed')
      end
    end

    context 'when status is cancelled' do
      let(:tenant) { create(:tenant) }
      let(:service) { create(:service, tenant: tenant) }
      let(:booking) { create(:booking, tenant: tenant, service: service, status: :cancelled) }

      it 'has the correct status' do
        expect(booking.status).to eq('cancelled')
      end
    end
  end

  describe 'scopes' do
    let(:tenant) { create(:tenant) }
    let(:service) { create(:service, tenant: tenant) }

    describe '#upcoming' do
      let!(:upcoming_booking) { create(:booking, tenant: tenant, service: service, scheduled_at: 1.day.from_now, status: :pending) }
      let!(:completed_booking) { create(:booking, tenant: tenant, service: service, scheduled_at: 1.day.ago, status: :completed) }
      let!(:cancelled_booking) { create(:booking, tenant: tenant, service: service, scheduled_at: 1.day.from_now, status: :cancelled) }

      it 'returns only upcoming bookings' do
        expect(described_class.upcoming).to eq([upcoming_booking])
      end
    end

    describe '#today' do
      let!(:today_booking) { create(:booking, tenant: tenant, service: service, scheduled_at: Time.current, status: :pending) }
      let!(:tomorrow_booking) { create(:booking, tenant: tenant, service: service, scheduled_at: 1.day.from_now, status: :pending) }

      it 'returns only today bookings' do
        expect(described_class.today).to eq([today_booking])
      end
    end
  end
end
