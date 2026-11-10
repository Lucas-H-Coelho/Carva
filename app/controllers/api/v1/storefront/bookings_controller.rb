# frozen_string_literal: true

module Api
  module V1
    class Storefront::BookingsController < StorefrontController
      def create
        tenant = Carva::Current.tenant
        service = Carva::Inventory::Service.find_by(id: params[:service_id])

        return render_json_error('Service not found', 404) unless service&.active?

        booking = Carva::Storefront::Booking.new(
          tenant: tenant,
          user: current_user,
          service: service,
          scheduled_at: params[:scheduled_at],
          notes: params[:notes]
        )

        if booking.save
          render_json_api(booking, status: :created)
        else
          render_json_error(booking.errors.full_messages.join(', '), 422)
        end
      end

      def index
        bookings = current_user&.bookings&.where(tenant: Carva::Current.tenant) || []
        bookings = bookings.order(scheduled_at: :desc)

        render_json_api_collection(bookings)
      end
    end
  end
end
