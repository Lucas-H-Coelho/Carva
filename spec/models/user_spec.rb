# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:tenant) { create(:tenant) }

    context 'when email is invalid' do
      subject { build(:user, tenant: tenant, email: 'invalid-email') }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include('is invalid')
      end
    end

    context 'when email is blank' do
      subject { build(:user, tenant: tenant, email: nil) }

      it 'is not valid' do
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("can't be blank")
      end
    end

    context 'when email is valid' do
      subject { build(:user, tenant: tenant, email: 'test@example.com') }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when email is uppercase' do
      subject { build(:user, tenant: tenant, email: 'Test@Example.com') }

      it 'downcases the email' do
        subject.valid?
        expect(subject.email).to eq('test@example.com')
      end
    end

    context 'when role is owner' do
      subject { build(:user, tenant: tenant, role: 'owner') }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'associations' do
    let(:tenant) { create(:tenant) }
    let(:user) { build(:user, tenant: tenant) }

    it { expect(user).to respond_to(:tenant) }
    it { expect(user).to respond_to(:bookings) }
  end

  describe 'api_key' do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant: tenant) }

    it 'generates a unique api_key' do
      expect(user.api_key).not_to be_nil
      expect(user.api_key).to be_a(String)
      expect(user.api_key.length).to eq(24)
    end
  end

  describe 'authenticate_devise?' do
    let(:tenant) { create(:tenant) }
    let(:user) { create(:user, tenant: tenant) }

    it 'returns true for correct password' do
      password = 'testpassword123'
      user.update_column(:encrypted_password, Digest::SHA256.hexdigest(password))
      expect(user.send(:authenticate_devise?, password)).to be true
    end

    it 'returns false for incorrect password' do
      user.update_column(:encrypted_password, Digest::SHA256.hexdigest('wrongpassword'))
      expect(user.send(:authenticate_devise?, 'testpassword123')).to be false
    end

    it 'returns false for blank password' do
      user.update_column(:encrypted_password, Digest::SHA256.hexdigest('testpassword123'))
      expect(user.send(:authenticate_devise?, '')).to be false
    end
  end
end
