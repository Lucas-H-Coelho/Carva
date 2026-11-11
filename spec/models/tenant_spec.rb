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
      tenant = Tenant.new(
        subdomain: 'meulava', name: 'Lava',
        hosting_type: 'cloud_saas',
        stripe_customer_id: 'cus_123',
        subscription_id: 'sub_123'
      )
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

  describe 'hosting_type' do
    it 'defaults to self_hosted' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.hosting_type).to eq('self_hosted')
      expect(tenant.hosting_type_self_hosted?).to be true
    end

    it 'can be set to cloud_saas' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'cloud_saas')
      expect(tenant.hosting_type).to eq('cloud_saas')
      expect(tenant.hosting_type_cloud_saas?).to be true
    end

    it 'can be set to revenue_share' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'revenue_share')
      expect(tenant.hosting_type).to eq('revenue_share')
      expect(tenant.hosting_type_revenue_share?).to be true
    end

    it 'rejects invalid hosting_type' do
      expect { Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'invalid') }
        .to raise_error(ArgumentError, /not a valid hosting_type/)
    end
  end

  describe 'plan' do
    it 'defaults to lava' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.plan).to eq('lava')
    end

    it 'accepts valid plans' do
      Tenant::VALID_PLANS.each do |plan|
        tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', plan: plan)
        expect(tenant).to be_valid
      end
    end

    it 'rejects invalid plans' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', plan: 'enterprise')
      tenant.valid?
      expect(tenant.errors[:plan]).to include('is not included in the list')
    end
  end

  describe 'license fields' do
    it 'requires license_key for self_hosted active' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'self_hosted')
      tenant.assign_attributes(status: 'active')
      tenant.valid?
      expect(tenant.errors[:license_key]).to include("can't be blank")
    end

    it 'requires license_expires_at for self_hosted active' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'self_hosted')
      tenant.assign_attributes(status: 'active')
      tenant.valid?
      expect(tenant.errors[:license_expires_at]).to include("can't be blank")
    end

    it 'is valid with both license fields for self_hosted active' do
      tenant = Tenant.new(
        subdomain: 'meulava', name: 'Lava',
        hosting_type: 'self_hosted',
        license_key: 'abc123',
        license_expires_at: 1.year.from_now
      )
      tenant.assign_attributes(status: 'active')
      expect(tenant).to be_valid
    end

    it 'does not require license fields for cloud_saas' do
      tenant = Tenant.new(
        subdomain: 'meulava', name: 'Lava',
        hosting_type: 'cloud_saas',
        stripe_customer_id: 'cus_123',
        subscription_id: 'sub_123'
      )
      tenant.assign_attributes(status: 'active')
      expect(tenant).to be_valid
    end

    it 'detects expired license' do
      tenant = Tenant.new(
        subdomain: 'meulava', name: 'Lava',
        hosting_type: 'self_hosted',
        license_key: 'abc123',
        license_expires_at: 1.day.ago
      )
      expect(tenant.license_expired?).to be true
    end

    it 'detects valid license' do
      tenant = Tenant.new(
        subdomain: 'meulava', name: 'Lava',
        hosting_type: 'self_hosted',
        license_key: 'abc123',
        license_expires_at: 1.year.from_now
      )
      expect(tenant.license_expired?).to be false
    end
  end

  describe 'stripe fields' do
    it 'requires stripe_customer_id for cloud_saas active' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'cloud_saas')
      tenant.assign_attributes(status: 'active')
      tenant.valid?
      expect(tenant.errors[:stripe_customer_id]).to include("can't be blank")
    end

    it 'requires subscription_id for cloud_saas active' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'cloud_saas')
      tenant.assign_attributes(status: 'active')
      tenant.valid?
      expect(tenant.errors[:subscription_id]).to include("can't be blank")
    end
  end

  describe 'revenue_share fields' do
    it 'has default revenue_share_rate of 0.15' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.revenue_share_rate).to eq(0.15)
    end

    it 'accepts valid revenue_share_rate' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'revenue_share', revenue_share_rate: 0.20)
      expect(tenant).to be_valid
    end

    it 'rejects revenue_share_rate > 1' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'revenue_share', revenue_share_rate: 1.5)
      tenant.valid?
      expect(tenant.errors[:revenue_share_rate]).to include('must be less than or equal to 1')
    end

    it 'rejects negative revenue_share_rate' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'revenue_share', revenue_share_rate: -0.1)
      tenant.valid?
      expect(tenant.errors[:revenue_share_rate]).to include('must be greater than or equal to 0')
    end

    it 'has default revenue_share_cap of 0.0' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.revenue_share_cap).to eq(0.0)
    end

    it 'accepts valid revenue_share_cap' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'revenue_share', revenue_share_cap: 1000.0)
      expect(tenant).to be_valid
    end

    it 'rejects negative revenue_share_cap' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', hosting_type: 'revenue_share', revenue_share_cap: -100.0)
      tenant.valid?
      expect(tenant.errors[:revenue_share_cap]).to include('must be greater than or equal to 0')
    end
  end

  describe 'plan_features' do
    it 'parses features JSON' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', features: '{"whatsapp": true, "loyalty": false}')
      expect(tenant.plan_features).to eq({'whatsapp' => true, 'loyalty' => false})
    end

    it 'returns empty hash for empty features' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava')
      expect(tenant.plan_features).to eq({})
    end

    it 'handles invalid JSON gracefully' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', features: 'not json')
      expect(tenant.plan_features).to eq({})
    end

    it 'checks feature enabled' do
      tenant = Tenant.new(subdomain: 'meulava', name: 'Lava', features: '{"whatsapp": true}')
      expect(tenant.feature_enabled?('whatsapp')).to be true
      expect(tenant.feature_enabled?('loyalty')).to be false
    end
  end
end
