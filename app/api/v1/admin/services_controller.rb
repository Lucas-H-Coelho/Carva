# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ServicesController < ApplicationController
        rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

        before_action :set_service, only: %i[show update destroy toggle_active]
        before_action :authorize_service, only: %i[show update destroy toggle_active]

        def index
          authorize_service_for_index
          services = current_tenant.services.order(:name)
          per_page = (params[:per_page] || 25).to_i
          page = (params[:page] || 1).to_i
          services = services.offset((page - 1) * per_page).limit(per_page).to_a
          render_json_api_collection(services)
        end

        def show
          render_json_api(@service)
        end

        def create
          policy = CarvaDashboard::ServicePolicy.new(current_user, Carva::Inventory::Service)
          return render_json_error('Forbidden', 403) unless policy.create?

          result = CarvaInventory::CreateService.new.call(tenant: current_tenant, **service_params)

          if result.success?
            render_json_api(result.data, status: :created)
          else
            render_json_error(result.errors.first, 422)
          end
        end

        def update
          result = CarvaInventory::UpdateService.new.call(@service.id, **service_params)

          if result.success?
            render_json_api(result.data)
          else
            render_json_error(result.errors.first, 422)
          end
        end

        def destroy
          result = CarvaInventory::DeleteService.new.call(@service.id)

          if result.success?
            head :no_content
          else
            render_json_error(result.errors.first, 422)
          end
        end

        def toggle_active
          @service.update_column(:active, !@service.active)
          render_json_api(@service)
        end

        private

        def service_params
          params.permit(:name, :slug, :description, :duration_minutes, :price_cents, :category, :active)
        end

        def set_service
          @service = current_tenant.services.find(params[:id])
        end

        def authorize_service
          policy = CarvaDashboard::ServicePolicy.new(current_user, @service)
          render_json_error('Forbidden', 403) unless policy.public_send("#{action_name}?")
        end

        def authorize_service_for_index
          policy = CarvaDashboard::ServicePolicy.new(current_user, Carva::Inventory::Service)
          render_json_error('Forbidden', 403) unless policy.index?
        end

        def render_not_found
          render_json_error('Record not found', 404)
        end
      end
    end
  end
end
