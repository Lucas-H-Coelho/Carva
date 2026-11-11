---
id: T-026
phase: Fase 2
priority: P0
status: todo
depends: T-013
tags: [feature, carva_storefront, carva_billing]
---

# T-026 — Services CRUD e gestão de preços

## Objetivo

Permitir que o dono crie, edite e delete serviços (lavagens, cera, polimento) com preço, tempo estimado e consumo de insumos. O S4 (gerente multi-tenant) define preço mínimo por tipo. Atende S1 (cadastrar preço), S2 (ver serviços e preços), S4 (preço mínimo por unidade).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Modelo | `Service` com `tenant_id`, `name`, `description`, `price`, `duration_minutes`, `consumption` (JSONB) |
| D2 | Preços por tenant | Cada unidade define seus próprios preços (S4 pode definir mínimo global) |
| D3 | Preço mínimo | `Tenant.minimum_price` por tipo de serviço, validado no create/update |
| D4 | Consumo de insumos | JSONB `{"shampoo": 0.5, "cera": 0.1}` — litros/kg por serviço |
| D5 | Status | `active`, `inactive` — não deletar, só desativar |

## Passo a Passo

### Passo 1 — Migration Services

```ruby
# db/migrate/20250101000013_create_services.rb
class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.references :tenant, null: false, type: :bigint
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :duration_minutes, null: false
      t.jsonb :consumption, default: '{}'
      t.string :status, default: 'active', null: false

      t.timestamps
    end

    add_index :services, [:tenant_id, :status]
  end
end
```

### Passo 2 — Modelo Service

```ruby
# app/models/service.rb
class Service < ApplicationRecord
  belongs_to :tenant

  enum :status, { active: 'active', inactive: 'inactive' }, prefix: true

  validates :name, :price, :duration_minutes, presence: true
  validates :price, numericality: { greater_than: 0 }

  before_validation :set_tenant

  def self.with_minimum_price(tenant, min_price)
    where('price >= ?', min_price)
  end

  def consumption_hash
    (consumption || {}).to_h
  end
end
```

### Passo 3 — Controller: Services

```ruby
# app/controllers/api/v1/services_controller.rb
module Api
  module V1
    class ServicesController < ApplicationController
      def index
        services = Current.tenant.services.where(status: 'active')
        render json: services
      end

      def create
        service = Current.tenant.services.build(service_params)
        if service.save
          render json: service, status: :created
        else
          render json: { errors: service.errors }, status: :bad_request
        end
      end

      def update
        service = Current.tenant.services.find(params[:id])
        if service.update(service_params)
          render json: service
        else
          render json: { errors: service.errors }, status: :bad_request
        end
      end

      def minimum_price
        render json: {
          minimum_price: Current.tenant.minimum_price || 0,
          message: 'Preço mínimo definido pela rede'
        }
      end

      private
      def service_params
        params.require(:service).permit(
          :name, :description, :price, :duration_minutes,
          :consumption, :status
        )
      end
    end
  end
end
```

## Checklist

- [ ] Migration `create_services` roda com sucesso
- [ ] `Service` model com preço, duração e consumo
- [ ] `Service.with_minimum_price` filtra por preço mínimo
- [ ] `ServicesController#index` retorna serviços ativos
- [ ] `ServicesController#create` cria serviço
- [ ] `ServicesController#update` atualiza serviço
- [ ] `ServicesController#minimum_price` retorna preço mínimo
- [ ] Testes RSpec: service model, controller, minimum price validation

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Preço abaixo do mínimo (S4) | Validar `Tenant.minimum_price` no controller |
| Consumo de insumos inválido | Validar JSONB schema no model |
| Serviço inativo ainda agendado | Verificar `status: 'active'` no booking create |
| Preço muda durante agendamento | Travar preço no booking criado |
