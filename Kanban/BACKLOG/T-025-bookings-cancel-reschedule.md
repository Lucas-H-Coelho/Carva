---
id: T-025
phase: Fase 2
priority: P0
status: todo
depends: T-024
tags: [feature, carva_storefront]
---

# T-025 — Reagendamento e cancelamento de bookings

## Objetivo

Permitir que clientes cancelem e reagendem agendamentos sem ligar. O cancelamento segue a regra de negócio: 2h+ antes = grátis, <2h = 50%, no-show = 100%. O reagendamento mostra horários disponíveis e permite troca em 2 toques. Atende S2 (cancelar, reagendar), S3 (cancelar/reagendar pelo app).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Cancelamento | Soft delete com `cancelled_at` + registro de multa |
| D2 | Multa | Calculada por `cancel_penalty(booking)` baseada em horas restantes |
| D3 | Reagendamento | Novo booking + cancela o antigo (ou update de `scheduled_at`) |
| D4 | Horários disponíveis | Query que exclui slots ocupados + horário de pico (13h-17h sex/sáb) |
| D5 | Notificação | WhatsApp automático ao cancelar/reagendar |

## Passo a Passo

### Passo 1 — Migration (cancelamento e multa)

```ruby
# db/migrate/20250101000012_add_cancellation_to_bookings.rb
class AddCancellationToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :cancelled_at, :datetime
    add_column :bookings, :cancellation_reason, :text
    add_column :bookings, :cancellation_penalty, :decimal, precision: 8, scale: 2, default: 0.00
    add_column :bookings, :original_scheduled_at, :datetime # para rastreiar reagendamento
  end
end
```

### Passo 2 — Serviço de Cancelamento

```ruby
# app/services/cancellation_service.rb
class CancellationService
  def self.cancel(booking, reason: nil)
    return unless booking.can_transition_to?('cancelled')

    penalty = calculate_penalty(booking)
    booking.cancelled_at = Time.now
    booking.cancellation_reason = reason
    booking.cancellation_penalty = penalty
    booking.transition_to!('cancelled')
  end

  def self.reschedule(booking, new_datetime)
    return unless booking.confirmed? || booking.pending?

    booking.original_scheduled_at = booking.scheduled_at
    booking.scheduled_at = new_datetime
    booking.save!
  end

  private
  def self.calculate_penalty(booking)
    hours_until = (booking.scheduled_at - Time.now) / 1.hour
    return 0 if hours_until > 2
    return booking.total * 0.5 if hours_until > 0
    return booking.total # no-show
  end
end
```

### Passo 3 — Controller: Cancellation

```ruby
# app/controllers/api/v1/cancellations_controller.rb
module Api
  module V1
    class CancellationsController < ApplicationController
      def cancel
        booking = Current.tenant.bookings.find(params[:id])
        CancellationService.cancel(booking, reason: params[:reason])
        render json: {
          success: true,
          penalty: booking.cancellation_penalty,
          message: "Cancelamento realizado. Multa: R$ #{booking.cancellation_penalty}"
        }
      end

      def reschedule
        booking = Current.tenant.bookings.find(params[:id])
        CancellationService.reschedule(booking, params[:new_datetime])
        render json: { success: true, booking: booking }
      end

      def available_slots
        tenant = Current.tenant
        date = params[:date]&.to_date || Date.today
        slots = BookingService.available_slots(tenant, date)
        render json: { date: date, slots: slots }
      end
    end
  end
end
```

## Checklist

- [ ] Migration `add_cancellation_to_bookings` roda com sucesso
- [ ] `CancellationService.cancel` calcula multa + marca cancelado
- [ ] `CancellationService.reschedule` atualiza horário
- [ ] `CancellationService.calculate_penalty` retorna 0/50%/100%
- [ ] `CancellationsController#cancel` cancela booking
- [ ] `CancellationsController#reschedule` reagenda booking
- [ ] `CancellationsController#available_slots` retorna slots livres
- [ ] Testes RSpec: cancellation service, controller, penalty calculation

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Cancelamento após início | Verificar `booking.in_progress?` antes de cancelar |
| No-show cobrado errado | Verificar `Time.now > scheduled_at + 30min` |
| Reagendamento para horário ocupado | Verificar disponibilidade antes de salvar |
| Multa não refletida no pagamento | Registrar `cancellation_penalty` no cash flow |
