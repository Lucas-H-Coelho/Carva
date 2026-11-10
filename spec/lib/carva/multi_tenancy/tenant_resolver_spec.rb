require 'rails_helper'

RSpec.describe Carva::MultiTenancy::TenantResolver do
  describe '#resolve' do
    let(:resolver) { described_class.new }

    context 'with a valid subdomain' do
      before do
        @tenant = Tenant.create!(subdomain: 'meulava', name: 'Lava Jato')
      end

      it 'finds the tenant by subdomain' do
        request = double(host: 'meulava.carva.test')
        result = resolver.resolve(request)
        expect(result).to eq(@tenant)
      end
    end

    context 'with www subdomain' do
      it 'returns nil' do
        request = double(host: 'www.carva.test')
        result = resolver.resolve(request)
        expect(result).to be_nil
      end
    end

    context 'with blank subdomain' do
      it 'returns nil' do
        request = double(host: 'carva.test')
        result = resolver.resolve(request)
        expect(result).to be_nil
      end
    end

    context 'with non-existent subdomain' do
      it 'returns nil' do
        request = double(host: 'unknown.carva.test')
        result = resolver.resolve(request)
        expect(result).to be_nil
      end
    end
  end
end
