---
id: T-024
phase: Fase 2
priority: P0
status: todo
depends: T-009, T-010, T-013
tags: [feature, carva_storefront, blocking]
---

# T-024 — Bookings CRUD completo com status workflow

## Objetivo

Implementar o modelo `Booking` com ciclo de vida completo: criado → confirmado → em andamento → concluído. Cada status muda o comportamento e libera ações diferentes. Atende S1 (ver agenda), S2 (agendar), S3 (marcar comecei/terminei).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Status enum | `pending`, `confirmed`, `in_progress`, `completed`, `cancelled` |
| D2 | Transição | Máquina de estados com `can_transition_to?` + `transition_to!` |
| D3 | Horário | `scheduled_at` (datetime) + `started_at` + `completed_at` |
| D4 | Atribuição | `assigned_to` (belongs_to :user, optional) — quem lava o carro |
| D5 | Walk-in | `Booking` criado sem `customer_id` (cliente não cadastrado) |

## Passo a Passo

### Passo 1 — Migration Bookings

```ruby
# db/migrate/20250101000011_create_bookings.rb
class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :tenant, null: false, type: :bigint
      t.references :customer, type: :bigint # nullable para walk-in
      t.references :service, null: false, foreign_key: true, type: :bigint
      t.references :assigned_to, foreign_key: { to_table: :users }, type: :bigint
      t.string :status, default: 'pending', null: false
      t.datetime :scheduled_at, null: false
      t.datetime :started_at
      t.datetime :completed_at
      t.decimal :total, precision: 8, scale: 2, default: 0.00
      t.text :notes
      t.string :payment_status, default: 'unpaid'

      t.timestamps
    end

    add_index :bookings, [:tenant_id, :status]
    add_index :bookings, :scheduled_at
  end
end
```

### Passo 2 — Modelo Booking

```ruby
# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :tenant
  belongs_to :customer, optional: true
  belongs_to :service
  belongs_to :assigned_to, class_name: 'User', optional: true

  enum :status, {
    pending: 'pending',
    confirmed: 'confirmed',
    in_progress: 'in_progress',
    completed: 'completed',
    cancelled: 'cancelled'
  }, prefix: true

  validates :scheduled_at, presence: true
  validates :status, presence: true

  before_validation :set_tenant

  def can_transition_to?(new_status)
    transitions = {
      'pending' => ['confirmed', 'cancelled'],
      'confirmed' => ['in_progress', 'cancelled'],
      'in_progress' => ['completed'],
      'completed' => [],
      'cancelled' => []
    }
    transitions[status]&.include?(new_status)
  end

  def transition_to!(new_status)
    return false unless can_transition_to?(new_status)
    self.status = new_status

    self.started_at = Time.now if new_status == 'in_progress'
    self.completed_at = Time.now if new_status == 'completed'

    save!
  end
end
```

### Passo 3 — Controller: Bookings

```ruby
# app/controllers/api/v1/bookings_controller.rb
module Api
  module V1
    class BookingsController < ApplicationController
      def index
        date = params[:date]&.to_date || Date.today
        bookings = Current.tenant.bookings
          .where(scheduled_at: date.beginning_of_day..date.end_of_day)
          .includes(:customer, :service, :assigned_to)
        render json: bookings
      end

      def create
        booking = Current.tenant.bookings.build(booking_params)
        if booking.save
          booking.transition_to!('confirmed')
          render json: booking, status: :created
        else
          render json: { errors: booking.errors }, status: :bad_request
        end
      end

      def update_status
        booking = Current.tenant.bookings.find(params[:id])
        if booking.transition_to!(params[:status])
          render json: booking
        else
          render json: { error: 'Transição inválida' }, status: :bad_request
        end
      end

      private
      def booking_params
        params.require(:booking).permit(
          :customer_id, :service_id, :scheduled_at, :notes,
          :assigned_to_id
        )
      end
    end
  end
end
```

## Checklist

- [ ] Migration `create_bookings` roda com sucesso
- [ ] `Booking` model com status enum e transições
- [ ] `Booking.can_transition_to?` valida transição
- [ ] `Booking.transition_to!` muda status + timestamps
- [ ] `BookingsController#index` retorna agendamentos do dia
- [ ] `BookingsController#create` cria + confirma booking
- [ ] `BookingsController#update_status` muda status
- [ ] Testes RSpec: booking model, controller, status transitions

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Horário de pico (13h-17h sex/sáb) | Validar no controller, bloquear agendamento |
| Conflito de horários | Verificar `bookings.where(scheduled_at: slot).exists?` |
| Booking sem customer (walk-in) | `customer` nullable, criar Customer se necessário |
| Status inválido | Enum + validação no model |
