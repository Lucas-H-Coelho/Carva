# frozen_string_literal: true

# Deleta um serviço existente.
module CarvaInventory
  class DeleteService < ApplicationService
    def self.call(service_id)
      new.call(service_id)
    end

    def call(service_id)
      service = Carva::Inventory::Service.find_by(id: service_id)
      return ApplicationService::FailureResult.new(['Service not found']) unless service

      return ApplicationService::FailureResult.new(['Failed to delete service']) unless service.destroy

      ApplicationService::SuccessResult.new(service)
    end
  end
end
