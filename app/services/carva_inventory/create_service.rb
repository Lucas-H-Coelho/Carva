# frozen_string_literal: true

# Cria um novo serviço do tenant.
module CarvaInventory
  class CreateService < ApplicationService
    def self.call(tenant: nil, **attrs)
      new.call(tenant: tenant, **attrs)
    end

    def call(tenant:, **attrs)
      return ApplicationService::FailureResult.new(['Tenant is required']) unless tenant

      form = CarvaInventory::ServiceForm.new(attrs)
      return ApplicationService::FailureResult.new(form.errors.full_messages) unless form.valid?

      service = Carva::Inventory::Service.new(tenant: tenant)
      return ApplicationService::FailureResult.new(form.errors.full_messages) unless form.persist(service)

      ApplicationService::SuccessResult.new(service)
    end
  end
end
