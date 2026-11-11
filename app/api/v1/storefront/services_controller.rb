# frozen_string_literal: true

module Api
  module V1
    class Storefront::ServicesController < StorefrontController
      skip_before_action :authenticate_request

      def index
        tenant = Carva::Current.tenant
        return render_json_error('Tenant not found', 404) unless tenant

        services = Carva::Inventory::Service
          .where(tenant: tenant)
          .where(active: true)
          .order(:category, :name)

        render_json_api_collection(services)
      end
    end
  end
end
