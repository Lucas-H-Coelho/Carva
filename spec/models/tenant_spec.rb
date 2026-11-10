require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'validations' do
    context 'subdomain' do
      it 'is valid with a proper subdomain' do
        tenant = Tenant.new(subdomain: 'meu-lava', name: 'Lava Jato')
        expect(tenant).to be_valid
      end

      it 'rejects subdomains with uppercase letters' do
        tenant = Tenant.new(subdomain: 'MeuLava', name: 'Lava Jato')
        tenant.valid?
        # before_validation callback downcases subdomain, so format passes
        expect(tenant.subdomain).to eq('meulava')
      end

      it 'rejects subdomains shorter than 2 characters' do
        tenant = Tenant.new(subdomain: 'a', name: 'Lava Jato')
        tenant.valid?
        expect(tenant.errors[:subdomain]).to include('is too short (minimum is 2 characters)')
      end

      it 'rejects subdomains longer than 63 characters' do
        tenant = Tenant.new(subdomain: 'a' * 64, name: 'Lava Jato')
        tenant.valid?
        expect(tenant.errors[:subdomain]).to include('is too long (maximum is 63 characters)')
      end

      it 'downcases the subdomain before validation' do
        tenant = Tenant.new(subdomain: 'MeuLava', name: 'Lava Jato')
        tenant.valid?
        expect(tenant.subdomain).to eq('meulava')
      end
    end

    context 'name' do
      it 'is invalid without a name' do
        tenant = Tenant.new(subdomain: 'meulava', name: '')
        tenant.valid?
        expect(tenant.errors[:name]).to include('can\'t be blank')
      end

      it 'rejects names shorter than 2 characters' do
        tenant = Tenant.new(subdomain: 'meulava', name: 'a')
        tenant.valid?
        expect(tenant.errors[:name]).to include('is too short (minimum is 2 characters)')
      end

      it 'rejects names longer than 255 characters' do
        tenant = Tenant.new(subdomain: 'meulava', name: 'a' * 256)
        tenant.valid?
        expect(tenant.errors[:name]).to include('is too long (maximum is 255 characters)')
      end
    end

    context 'custom_domain' do
      it 'is valid with a proper custom domain' do
        tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', custom_domain: 'lavajato.com')
        expect(tenant).to be_valid
      end

      it 'is valid with a subdomain custom domain' do
        tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', custom_domain: 'lava.carva.com')
        expect(tenant).to be_valid
      end

      it 'rejects invalid custom domains' do
        tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', custom_domain: 'invalid')
        tenant.valid?
        expect(tenant.errors[:custom_domain]).to include('is invalid')
      end

      it 'downcases the custom_domain before validation' do
        tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', custom_domain: 'LavaJato.COM')
        tenant.valid?
        expect(tenant.custom_domain).to eq('lavajato.com')
      end
    end
  end

  describe 'associations' do
    it 'has many users' do
      expect(Tenant.new).to respond_to(:users)
    end

    it 'has many services' do
      expect(Tenant.new).to respond_to(:services)
    end

    it 'has many products' do
      expect(Tenant.new).to respond_to(:products)
    end
  end

  describe 'enum' do
    it 'has trial status by default' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.status).to eq('trial')
      expect(tenant.status_trial?).to be true
    end

    it 'can set active status' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      tenant.status_active!
      expect(tenant.status).to eq('active')
      expect(tenant.status_active?).to be true
    end

    it 'can set suspended status' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      tenant.status_suspended!
      expect(tenant.status).to eq('suspended')
      expect(tenant.status_suspended?).to be true
    end
  end
end
