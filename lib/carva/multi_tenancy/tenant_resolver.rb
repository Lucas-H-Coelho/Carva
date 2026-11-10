module Carva
  module MultiTenancy
    class TenantResolver
      def resolve(request)
        subdomain = request.host.split('.').first
        return nil if subdomain.blank? || subdomain == 'www'
        Tenant.find_by(subdomain: subdomain)
      end
    end
  end
end
