# frozen_string_literal: true

module Api
  module V1
    class PublicController < ApplicationController
      skip_before_action :authenticate_request, raise: false

      def health
        render json: {
          status: 'ok',
          version: 'v1',
          timestamp: Time.current.iso8601
        }, status: :ok
      end

      def services
        tenant = Carva::Current.tenant
        services = tenant.services.active if tenant&.services
        render_json_api_collection(services || [], status: :ok)
      end

      def available_slots
        tenant = Carva::Current.tenant
        slots = []

        if tenant&.services&.active&.any?
          tenant.services.active.each do |service|
            slots << {
              id: service.id,
              name: service.name,
              duration: service.duration_minutes,
              available: true
            }
          end
        end

        render json: {
          data: slots.map { |s| { id: s[:id], type: 'slot', attributes: s } },
          meta: { version: 'v1' }
        }, status: :ok
      end
    end
  end
end
