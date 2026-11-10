---
id: T-023
phase: Fase 2
priority: P0
status: todo
depends: T-009, T-013
tags: [feature, carva_core, security, blocking]
---

# T-023 — Autenticação WhatsApp (OTP sem senha)

## Objetivo

Permitir que clientes e funcionários façam login apenas com número de WhatsApp, sem senha. O dono mantém login Devise (email + senha). Isso atende S2 (cliente), S3 (funcionário) e S1 (donos que querem acesso rápido).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Método de auth | OTP via WhatsApp (código de 6 dígitos enviado por mensagem) |
| D2 | Armazenamento OTP | `otp_code`, `otp_expires_at`, `otp_attempt` no model User |
| D3 | Provider | Twilio API (ou similar) para envio de WhatsApp messages |
| D4 | Session | JWT com `otp: true` se login foi por WhatsApp, `otp: false` se Devise |
| D5 | Rate limiting | Máximo 3 tentativas por minuto por número, bloqueio temporário |

## Passo a Passo

### Passo 1 — Migration Users (campos OTP)

```ruby
# db/migrate/20250101000010_add_otp_to_users.rb
class AddOtpToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :otp_code, :string, limit: 6
    add_column :users, :otp_expires_at, :datetime
    add_column :users, :otp_attempt, :integer, default: 0
    add_column :users, :phone_verified_at, :datetime

    add_index :users, :phone_number
  end
end
```

### Passo 2 — Modelo User (OTP methods)

```ruby
# app/models/user.rb
class User < ApplicationRecord
  # ... existing code ...

  def send_otp
    code = rand(100000..999999).to_s
    self.otp_code = code
    self.otp_expires_at = 5.minutes.from_now
    self.otp_attempt = (otp_attempt || 0) + 1
    save!
    send_whatsapp_otp(phone_number, code)
  end

  def verify_otp(code)
    return false if otp_code.blank? || otp_expires_at < Time.now
    return false if otp_attempt >= 3

    result = otp_code == code
    if result
      self.phone_verified_at = Time.now
      self.otp_code = nil
      save!
    end
    result
  end
end
```

### Passo 3 — Controller: WhatsApp Auth

```ruby
# app/controllers/api/v1/whatsapp_auth_controller.rb
module Api
  module V1
    class WhatsappAuthController < ApplicationController
      skip_before_action :authenticate_request

      def send_otp
        user = User.find_by(phone_number: params[:phone_number]) ||
               User.create!(
                 phone_number: params[:phone_number],
                 tenant: Current.tenant,
                 role: params[:role] || 'customer'
               )
        user.send_otp
        render json: { message: 'OTP enviado', phone: user.phone_number }
      end

      def verify_otp
        user = User.find_by(phone_number: params[:phone_number])
        if user&.verify_otp(params[:code])
          render json: { token: user.generate_jwt, otp: true }
        else
          render json: { error: 'OTP inválido' }, status: :unauthorized
        end
      end
    end
  end
end
```

## Checklist

- [ ] Migration `add_otp_to_users` roda com sucesso
- [ ] `User.send_otp` gera código e envia via WhatsApp
- [ ] `User.verify_otp` valida código + rate limiting
- [ ] `WhatsappAuthController#send_otp` cria usuário se necessário
- [ ] `WhatsappAuthController#verify_otp` retorna JWT
- [ ] JWT gerado com `otp: true` no payload
- [ ] Testes RSpec: OTP flow, rate limiting, user creation

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Twilio não configurado | Fallback para SMS ou código manual |
| OTP expira rápido | 5 minutos é suficiente, mas logar expirações |
| Rate limiting bypass | Bloquear IP + número no Redis |
| Usuário duplicado | Verificar `phone_number` antes de criar |
