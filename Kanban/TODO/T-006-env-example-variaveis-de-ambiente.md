---
id: T-006
phase: Fase 0
priority: P1
status: todo
depends: none
---

# T-006 — .env.example + variáveis de ambiente

## Descrição

Criar `.env.example` com todas as variáveis de ambiente necessárias para o projeto, sem credenciais reais.

## Escopo

- Variáveis de banco de dados (PostgreSQL)
- Variáveis de cache (Redis)
- Variáveis de auth (JWT secret, session secret)
- Variáveis de Stripe (test keys)
- Variáveis de Twilio (test credentials)
- Variáveis de Sentry (DSN)
- Variáveis de Sidekiq

## Acceptance Criteria

- [ ] `.env.example` criado com todas as variáveis
- [ ] `.env` adicionado ao `.gitignore`
- [ ] Variáveis organizadas por categoria (comentários)
- [ ] Valores placeholder explicativos (não reais)
- [ ] `config/environments/*.rb` lê variáveis do env
- [ ] `dotenv-rails` configurado para ler `.env`

## Implementation Notes

```bash
# .env.example
# Database
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/carva_dev

# Redis
REDIS_URL=redis://localhost:6379/0

# JWT
JWT_SECRET=change_me_in_production

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Twilio
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token

# Sentry
SENTRY_DSN=

# Sidekiq
SIDEKIQ_REDIS_URL=redis://localhost:6379/1
```

## Dependencies

- T-002 (PostgreSQL + Redis Docker Compose)
