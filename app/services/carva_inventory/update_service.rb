# frozen_string_literal: true

# Atualiza um serviço existente.
module CarvaInventory
  class UpdateService < ApplicationService
    def self.call(service_id, **attrs)
      new.call(service_id, **attrs)
    end

    def call(service_id, **attrs)
      service = Carva::Inventory::Service.find_by(id: service_id)
      return ApplicationService::FailureResult.new(['Service not found']) unless service

      form = CarvaInventory::ServiceForm.new(attrs)
      return ApplicationService::FailureResult.new(form.errors.full_messages) unless form.valid?

      return ApplicationService::FailureResult.new(form.errors.full_messages) unless form.persist(service)

      ApplicationService::SuccessResult.new(service)
    end
  end
end
