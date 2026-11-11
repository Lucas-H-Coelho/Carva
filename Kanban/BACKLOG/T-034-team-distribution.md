---
id: T-034
phase: Fase 2
priority: P0
status: todo
depends: T-009, T-024
tags: [feature, carva_storefront, carva_core]
---

# T-034 — Distribuição de carros entre funcionários

## Objetivo

Permitir que o "chefe de serviço" (S3) distribua carros entre funcionários, reatribua se alguém sair, e que cada funcionário veja apenas o carro designado pra ele. Atende S3 (distribuir, ver quem lava qual carro, reatribuir), S1 (ver equipe).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Atribuição | `Booking.assigned_to` (FK para User) — um carro por funcionário |
| D2 | Chef de serviço | `role: :shift_lead` pode ver/distribuir todos os carros |
| D3 | Funcionário comum | Vê só `bookings.where(assigned_to: current_user)` |
| D4 | Reatribuição | `Booking.reassign_to!(new_user)` + notificação WhatsApp |
| D5 | Disponibilidade | `User.available_today?` baseado em `shifts` table |

## Passo a Passo

### Passo 1 — Migration Shifts (disponibilidade)

```ruby
# db/migrate/20250101000021_create_shifts.rb
class CreateShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :shifts do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.date :date, null: false
      t.boolean :available, default: true
      t.string :status, default: 'scheduled' # scheduled, on_break, off_duty

      t.timestamps
    end

    add_index :shifts, [:user_id, :date], unique: true
  end
end
```

### Passo 2 — Modelo User (team methods)

```ruby
# app/models/user.rb
class User < ApplicationRecord
  enum :role, { owner: 'owner', shift_lead: 'shift_lead', employee: 'employee' }, prefix: true

  # ... existing code ...

  def available_today?(date = Date.today)
    shift = shifts.find_by(date: date)
    shift&.available == true && shift.status != 'off_duty'
  end

  def assigned_bookings(date = Date.today)
    bookings.where(
      tenant_id: tenant_id,
      scheduled_at: date.beginning_of_day..date.end_of_day,
      assigned_to_id: id
    )
  end

  def shift_lead?
    role == 'shift_lead'
  end
end
```

### Passo 3 — Modelo Booking (reassignment)

```ruby
# app/models/booking.rb
class Booking < ApplicationRecord
  belongs_to :assigned_to, class_name: 'User', optional: true

  # ... existing code ...

  def reassign_to!(new_user)
    return false if new_user.nil?
    return false if in_progress? && new_user == assigned_to

    old_user = assigned_to
    self.assigned_to = new_user
    save!

    # Notificar ambos
    if old_user && old_user.phone_number
      send_whatsapp_notification(old_user, "Seu carro #{customer_name} foi reatribuído para #{new_user.name}")
    end
    if new_user.phone_number
      send_whatsapp_notification(new_user, "Novo carro atribuído: #{customer_name} às #{scheduled_at.strftime('%H:%M')}")
    end

    true
  end

  def can_assign?
    pending? || confirmed?
  end
end
```

### Passo 4 — Controller: TeamDistribution

```ruby
# app/controllers/api/v1/team_controller.rb
module Api
  module V1
    class TeamController < ApplicationController
      before_action :require_shift_lead_or_owner, only: [:distribute, :reassign]

      def today_team
        tenant = Current.tenant
        render json: {
          date: Date.today,
          team: tenant.users.where.not(role: 'owner').includes(:shifts),
          bookings: tenant.bookings
            .where(scheduled_at: Date.today.beginning_of_day..Date.today.end_of_day)
            .includes(:customer, :service, :assigned_to)
        }
      end

      def distribute
        tenant = Current.tenant
        booking = tenant.bookings.find(params[:booking_id])
        user = tenant.users.find(params[:user_id])

        if booking.reassign_to!(user)
          render json: { success: true, booking: booking.as_json(include: [:customer, :service, :assigned_to]) }
        else
          render json: { error: 'Não pode reatribuir' }, status: :bad_request
        end
      end

      def reassign
        booking = Current.tenant.bookings.find(params[:booking_id])
        new_user = Current.tenant.users.find(params[:new_user_id])

        if booking.reassign_to!(new_user)
          render json: { success: true }
        else
          render json: { error: 'Reatribuição falhou' }, status: :bad_request
        end
      end

      def my_bookings
        render json: Current.user.assigned_bookings
      end

      private
      def require_shift_lead_or_owner
        unless Current.user.owner? || Current.user.shift_lead?
          render json: { error: 'Permissão negada' }, status: :forbidden
        end
      end
    end
  end
end
```

## Checklist

- [ ] Migration `create_shifts` roda com sucesso
- [ ] `User.available_today?` verifica disponibilidade
- [ ] `User.assigned_bookings` retorna carros do funcionário
- [ ] `Booking.reassign_to!` reatribui e envia notificação
- [ ] `TeamController#today_team` retorna equipe + agendamentos
- [ ] `TeamController#distribute` permite distribuição (shift_lead/owner)
- [ ] `TeamController#reassign` permite reatribuição
- [ ] `TeamController#my_bookings` retorna só os carros do funcionário
- [ ] Notificações WhatsApp enviadas na reatribuição
- [ ] Testes RSpec: team controller, booking reassignment, user availability

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Dois chefes redistribuindo ao mesmo tempo | Lock otimista no Booking |
| Funcionário não vê seus carros | Query filtrada por `assigned_to_id` |
| Notificação falha | Logar erro, não bloquear reatribuição |
| Shift_lead muda de papel | Verificar role em cada request |
