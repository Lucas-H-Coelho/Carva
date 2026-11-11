---
id: T-009
phase: Fase 1
priority: P0
status: done
depends: T-008
tags: [feature, carva_core, blocking, security]
---

# T-009 — User model + Devise authentication

## Objetivo

Implementar o modelo `User` com Devise + devise-jwt, scoping por tenant, e endpoints de auth (register, login, logout, me).

---

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Devise modules | `database_authenticatable`, `registerable`, `recoverable`, `validatable` — **sem session** (API mode) |
| D2 | JWT | `devise-jwt` com signing `secret_key_base`, `aud_claim: tenant subdomain` |
| D3 | User roles | `role: :owner` (único por tenant no início) |
| D4 | Scoping | `default_scope { where(tenant_id: Current.tenant) }` |
| D5 | API key | Gerar `api_key` (uuid) por user para X-Carva-API-Key |

---

## Passo a Passo

### Passo 1 — Migration Users

```ruby
# db/migrate/20250101000002_create_users.rb
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :role, default: 'owner', null: false
      t.string :api_key, limit: 36
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :users, [ :tenant_id, :email ], unique: true
    add_index :users, :api_key, unique: true
    add_index :users, :tenant_id
  end
end
```

### Passo 2 — Modelo User

```ruby
# app/models/user.rb
class User < ApplicationRecord
  enum :role, { owner: 'owner' }, prefix: true

  belongs_to :tenant
  has_many :bookings, class_name: 'Carva::Storefront::Booking'

  has_secure_token :api_key

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  validates :role, presence: true

  before_validation :downcase_email

  def authenticate_devise(password)
    return false if encrypted_password.blank?
    ActiveSupport::SecurityUtils.secure_compare(
      digest(password), encrypted_password
    )
  end

  private
  def digest(str)
    ::Digest::SHA256.hexdigest(str)
  end
end
```

### Passo 3 — Devise Initializer

```ruby
# config/initializers/devise.rb
# Configurações padrão + JWT
Devise.setup do |config|
  config.secret_key = Rails.application.secret_key_base
  config.token_key = 'encrypted_password'
end
```

### Passo 4 — Auth Controller

```ruby
# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_request

      def create
        tenant = Carva::Current.tenant
        user = tenant.users.find_by(email: params[:email])

        if user&.authenticate_devise(params[:password])
          render json: { token: user.generate_jwt }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def me
        render json: { user: Current.user.as_json(include: %i[email role]) }
      end

      def destroy
        # Stateless JWT — no server-side logout needed
        head :no_content
      end
    end
  end
end
```

### Passo 5 — Routes

```ruby
# app/engines/carva_core/lib/carva/core/engine.rb
# mount routes dentro do engine
scope module: 'api/v1' do
  post 'sessions', to: 'sessions#create'
  get 'sessions/me', to: 'sessions#me'
  delete 'sessions', to: 'sessions#destroy'
end
```

---

## Checklist de Aceitação

- [ ] Migration `create_users` roda com sucesso
- [ ] Modelo `User` com `tenant_id`, `email`, `password`, `api_key`
- [ ] `authenticate_devise` funciona (SHA256 digest)
- [ ] Controller `sessions#create` retorna JWT token
- [ ] Controller `sessions#me` retorna user atual
- [ ] JWT gerado com `devise-jwt` (secret_key_base signing)
- [ ] Testes RSpec: auth flow, JWT, scoping
- [ ] `bin/rails db:migrate` limpo

---

## Riscos

| Risco | Mitigação |
|-------|-----------|
| SHA256 vs bcrypt | Usar `has_secure_password` + bcrypt gem se necessário |
| JWT expira muito rápido | Configurar `exp: 7.days` no payload |
| `api_key` não gerado | `before_create :has_secure_token` no model |
| Password em clear text | Hash no controller antes de salvar |
