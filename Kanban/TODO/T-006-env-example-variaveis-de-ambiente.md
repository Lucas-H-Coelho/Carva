---
id: T-006
phase: Fase 0
priority: P1
status: todo
depends: T-002
---

# T-006 — .env.example + variáveis de ambiente

## Objetivo

Criar `.env.example` com todas as variáveis de ambiente necessárias para o projeto, sem credenciais reais.

---

## Decisões a Tomar (antes de começar)

| # | Decisão | Opção A | Opção B | Recomendação |
|---|---------|---------|---------|-------------|
| D1 | Env library | `dotenv-rails` | `figaro` | **`dotenv-rails`** — mais popular, mantém `.env` local |
| D2 | Config pattern | `config_for` | `Rails.application.config_for` | **`config_for`** — Rails 7+ nativo |
| D3 | Validation | `dotenv-linter` | `dotenv-safe` | **`dotenv-linter`** — mais leve, CLI simples |
| D4 | Secrets | `Rails.application.credentials` | `vault` | **`credentials`** — Rails nativo, encryptado |
| D5 | Multi-env | `.env.development` | `.env.test` | **Ambos** — Rails suporta automaticamente |

---

## Passo a Passo

### Passo 1 — Criar `.env.example`

```bash
# ============================================================
# DATABASE
# ============================================================
# PostgreSQL connection
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=carva_dev
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres

# Test database (automatically set by Rails)
# DATABASE_TEST_NAME=carva_test

# ============================================================
# REDIS / CACHE
# ============================================================
REDIS_URL=redis://localhost:6379/0
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Sidekiq Redis (separate DB for queue)
SIDEKIQ_REDIS_URL=redis://localhost:6379/1

# ============================================================
# RAILS
# ============================================================
RAILS_ENV=development
RAILS_LOG_LEVEL=debug
RAILS_MAX_THREADS=5
RAILS_SERVING_STATIC_FILES=true
RAILS_FORCE_SESSION=false
RAILS_DEVELOPMENT_HOSTS=localhost,127.0.0.1,api.localhost

# Secret keys (generate with: rails secret)
SECRET_KEY_BASE=CHANGE_ME_REPLACE_WITH_RAILS_SECRET
SESSION_SECRET=CHANGE_ME_REPLACE_WITH_RAILS_SECRET

# ============================================================
# AUTH / JWT
# ============================================================
JWT_SECRET=CHANGE_ME_REPLACE_WITH_JWT_SECRET
JWT_EXPIRATION=86400
JWT_ISSUER=carva-api

# ============================================================
# STRIPE (Payments)
# ============================================================
STRIPE_PUBLISHABLE_KEY=pk_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
STRIPE_SECRET_KEY=sk_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
STRIPE_WEBHOOK_SECRET=whsec_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# ============================================================
# TWILIO (SMS)
# ============================================================
TWILIO_ACCOUNT_SID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
TWILIO_AUTH_TOKEN=CHANGE_ME_REPLACE_WITH_TWILIO_TOKEN
TWILIO_PHONE_NUMBER=+1XXXXXXXXXX

# ============================================================
# SENTRY (Error Tracking)
# ============================================================
SENTRY_DSN=
SENTRY_ENVIRONMENT=development

# ============================================================
# ACTION MAILER (Email)
# ============================================================
MAILER_DEFAULT_FROM=noreply@carva.com
MAILER_DEFAULT_REPLY_TO=noreply@carva.com
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=
SMTP_PASSWORD=
SMTP_DOMAIN=

# ============================================================
# CLOUDFLARE (CDN)
# ============================================================
CLOUDFLARE_API_KEY=
CLOUDFLARE_EMAIL=
CLOUDFLARE_ZONE_ID=

# ============================================================
# OPENAI (Optional - for future AI features)
# ============================================================
OPENAI_API_KEY=
OPENAI_MODEL=gpt-4o-mini
```

### Passo 2 — Criar `.env` (local, ignorado no git)

```bash
# Copiar de .env.example e substituir valores
cp .env.example .env
```

### Passo 3 — Atualizar `.gitignore`

```
# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Credentials
config/credentials/*.yml.enc
config/credentials/*.key

# Docker
docker-compose.override.yml

# Editor
.vscode/
.idea/
*.swp
*.swo
```

### Passo 4 — Criar `config/application.yml`

```yaml
# config/application.yml
# This file is git-ignored. Use credentials instead.
# Rails.application.credentials.dig(:stripe, :secret_key)
```

### Passo 5 — Configurar `config/environments/development.rb`

```ruby
# config/environments/development.rb
module Carva
  class Application < Rails::Application
    config.hosts << 'localhost'
    config.hosts << 'api.localhost'

    # Load environment variables
    config.load_defaults 7.1

    # ActionMailer
    config.action_mailer.default_url_options = {
      host: ENV.fetch('RAILS_HOST', 'localhost:3000')
    }
  end
end
```

### Passo 6 — Configurar `config/environments/production.rb`

```ruby
# config/environments/production.rb
module Carva
  class Application < Rails::Application
    config.hosts << ENV.fetch('RAILS_HOST', 'carva.com')

    # Force SSL
    config.force_ssl = true

    # Log level
    config.log_level = :info

    # ActionMailer
    config.action_mailer.default_url_options = {
      host: ENV.fetch('RAILS_HOST', 'carva.com')
    }
  end
end
```

### Passo 7 — Configurar `config/environments/test.rb`

```ruby
# config/environments/test.rb
module Carva
  class Application < Rails::Application
    config.hosts << 'test.localhost'

    # Test database
    config.database_cleaner = {
      strategy: :transaction
    }
  end
end
```

---

## Checklist de Aceitação

- [ ] `.env.example` criado com todas as variáveis
- [ ] `.env` adicionado ao `.gitignore`
- [ ] Variáveis organizadas por categoria (comentários)
- [ ] Valores placeholder explicativos (não reais)
- [ ] `config/environments/*.rb` lê variáveis do env
- [ ] `dotenv-rails` configurado para ler `.env`
- [ ] `SECRET_KEY_BASE` gerado com `rails secret`
- [ ] `JWT_SECRET` gerado com `SecureRandom.hex(64)`
- [ ] `.env.local` ignorado no git
- [ ] `config/credentials/*.yml.enc` ignorado no git

---

## Arquivos que devem existir ao final

```
Carva/
├── .env.example
├── .env
├── .gitignore
├── config/
│   ├── application.yml
│   └── environments/
│       ├── development.rb
│       ├── production.rb
│       └── test.rb
```

---

## Notas de Implementação

- **`dotenv-rails`** lê `.env` automaticamente em development/test
- **`SECRET_KEY_BASE`** deve ser gerado com `rails secret`
- **`JWT_SECRET`** deve ser gerado com `SecureRandom.hex(64)`
- **`config/credentials/*.yml.enc`** é encryptado e não deve ser commitado
- **`.env.local`** é para overrides locais (não commitar)

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| Credenciais no git | `.gitignore` + CI scan |
| Variáveis faltando | `dotenv-linter` no CI |
| Secrets em produção | `Rails.application.credentials` |
| Env vars não carregadas | `dotenv-rails` no Gemfile |
| Diferenças dev/prod | `.env.development` vs `.env.production` |

---

## Comandos para Testar Localmente

```bash
# Gerar secret keys
rails secret
openssl rand -hex 64

# Validar .env
dotenv-linter .env.example

# Verificar variáveis carregadas
rails console
> ENV['DATABASE_HOST']
> ENV['REDIS_URL']

# Gerar credentials
rails credentials:edit
```