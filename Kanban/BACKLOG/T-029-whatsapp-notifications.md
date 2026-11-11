---
id: T-029
phase: Fase 2
priority: P0
status: todo
depends: T-024, T-023
tags: [feature, carva_marketing, blocking]
---

# T-029 — Notificações WhatsApp (confirmação, pronto, lembrete)

## Objetivo

Enviar mensagens automáticas via WhatsApp para clientes e donos em eventos-chave: confirmação de agendamento, carro pronto, lembrete antes do horário, alerta de estoque baixo. Atende S1 (alerta estoque), S2 (confirmação, aviso pronto, lembrete), S4 (alerta por unidade).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Provider | Twilio WhatsApp API (ou API genérica com adapter) |
| D2 | Templates | Mensagens pré-definidas, personalizáveis por tenant |
| D3 | Timing | Job assíncrono (Sidekiq) para lembretes com delay |
| D4 | Opt-out | Campo `opt_out_whatsapp` no user para GDPR |
| D5 | Log | `NotificationLog` model para rastrear envios |

## Passo a Passo

### Passo 1 — Migration NotificationLogs

```ruby
# db/migrate/20250101000017_create_notification_logs.rb
class CreateNotificationLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_logs do |t|
      t.references :tenant, type: :bigint
      t.string :recipient_type, null: false # customer, owner, employee
      t.string :recipient_phone, null: false
      t.string :template, null: false
      t.text :body
      t.string :status, default: 'pending', null: false # pending, sent, failed
      t.text :error_message
      t.datetime :sent_at

      t.timestamps
    end

    add_index :notification_logs, [:tenant_id, :recipient_phone, :template]
  end
end
```

### Passo 2 — Templates de Mensagem

```ruby
# app/services/whatsapp_templates.rb
class WhatsappTemplates
  def self.booking_confirmation(customer, booking)
    "Olá #{customer.name}! Sua lavagem #{booking.service.name} está agendada para #{booking.scheduled_at.strftime('%d/%m às %H:%M')}. Confirma? Responda SIM ou NÃO."
  end

  def self.car_ready(customer)
    "Seu carro está pronto para retirada! 🚗 Venha buscar ou agende nova lavagem: #{booking_url}"
  end

  def self.booking_reminder(customer, booking)
    "Lembrete: Sua lavagem #{booking.service.name} é amanhã às #{booking.scheduled_at.strftime('%H:%M')}. Confirma? Responda SIM ou NÃO."
  end

  def self.low_stock(tenant, product)
    "⚠️ Estoque baixo: #{product.name} (#{product.quantity} #{product.unit} restantes). Compre reposição!"
  end

  def self.booking_cancelled(customer, booking)
    "Seu agendamento #{booking.service.name} foi cancelado. Multa: R$ #{booking.cancellation_penalty}. Motivo: #{booking.cancellation_reason}"
  end
end
```

### Passo 3 — Service: NotificationService

```ruby
# app/services/notification_service.rb
class NotificationService
  def self.send(template_name, recipient, **variables)
    return if recipient.opt_out_whatsapp

    body = WhatsappTemplates.send(template_name, **variables)
    log = NotificationLog.create!(
      tenant: variables[:tenant],
      recipient_type: recipient.class.name.underscore,
      recipient_phone: recipient.phone_number,
      template: template_name,
      body: body,
      status: 'pending'
    )

    send_via_twilio(log)
  end

  def self.on_booking_created(booking)
    send('booking_confirmation', booking.customer, tenant: booking.tenant, booking: booking)
  end

  def self.on_booking_completed(booking)
    send('car_ready', booking.customer, tenant: booking.tenant, booking: booking)
  end

  def self.on_booking_scheduled(booking)
    # Lembrete 1h antes
    SendReminderWorker.perform_in(1.hour, booking.id)
  end

  private
  def self.send_via_twilio(log)
    # TODO: Implementar envio via Twilio
    log.status = 'sent'
    log.sent_at = Time.now
    log.save!
  rescue => e
    log.status = 'failed'
    log.error_message = e.message
    log.save!
  end
end
```

### Passo 4 — Worker: SendReminder

```ruby
# app/workers/send_reminder_worker.rb
class SendReminderWorker
  def self.perform(booking_id)
    booking = Booking.find(booking_id)
    return unless booking&.confirmed? || booking&.pending?

    NotificationService.send('booking_reminder', booking.customer, tenant: booking.tenant, booking: booking)
  end
end
```

## Checklist

- [ ] Migration `create_notification_logs` roda com sucesso
- [ ] `WhatsappTemplates` retorna mensagens para cada evento
- [ ] `NotificationLog` model com status e template
- [ ] `NotificationService.send` cria log + envia via Twilio
- [ ] `NotificationService.on_booking_created` envia confirmação
- [ ] `NotificationService.on_booking_completed` envia aviso pronto
- [ ] `NotificationService.on_booking_scheduled` agenda lembrete
- [ ] `SendReminderWorker` envia lembrete 1h antes
- [ ] Testes RSpec: notification service, templates, worker

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Twilio não configurado | Logar erro, não bloquear fluxo |
| Opt-out não respeitado | Verificar `opt_out_whatsapp` antes de enviar |
| Template inválido | Validar template name no service |
| Notificação duplicada | Verificar `notification_logs.where(template: template, recipient_phone: phone, status: 'sent').last` |
