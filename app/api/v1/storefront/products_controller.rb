# frozen_string_literal: true

module Api
  module V1
    class Storefront::ProductsController < StorefrontController
      skip_before_action :authenticate_request

      def index
        tenant = Carva::Current.tenant
        return render_json_error('Tenant not found', 404) unless tenant

        products = Carva::Inventory::Product
          .where(tenant: tenant)
          .where(active: true)
          .order(:name)

        render_json_api_collection(products)
      end
    end
  end
end
