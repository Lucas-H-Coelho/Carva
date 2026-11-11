# frozen_string_literal: true

# Policy para autorização de serviços no dashboard admin.
# Owner pode tudo. Shift lead pode index, show, create, update.
module CarvaDashboard
  class ServicePolicy < ApplicationPolicy
    def index?
      user.present?
    end

    def show?
      user.present?
    end

    def create?
      user.present?
    end

    def update?
      user.present? && (user.role_owner? || user.role_shift_lead?)
    end

    def destroy?
      user.present? && user.role_owner?
    end

    def toggle_active?
      user.present? && user.role_owner?
    end
  end
end
