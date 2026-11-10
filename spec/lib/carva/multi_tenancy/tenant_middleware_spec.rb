require 'rails_helper'

RSpec.describe Carva::MultiTenancy::TenantMiddleware do
  let(:app) { ->(_env) { [200, {}, ['OK']] } }
  let(:middleware) { described_class.new(app) }

  before do
    Tenant.create!(subdomain: 'meulava', name: 'Lava Jato')
  end

  it 'sets Carva::Current.tenant from subdomain' do
    env = {
      'HTTP_HOST' => 'meulava.carva.test',
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/'
    }

    middleware.call(env)

    expect(Carva::Current.tenant).to be_a(Tenant)
    expect(Carva::Current.tenant.subdomain).to eq('meulava')
  end

  it 'sets Carva::Current.tenant to nil when no tenant matches' do
    env = {
      'HTTP_HOST' => 'www.carva.test',
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/'
    }

    middleware.call(env)

    expect(Carva::Current.tenant).to be_nil
  end

  it 'calls the next middleware' do
    env = {
      'HTTP_HOST' => 'meulava.carva.test',
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/'
    }

    status, headers, body = middleware.call(env)

    expect(status).to eq(200)
    expect(body).to eq(['OK'])
  end
end
