# Infra Agent Profile

> **Stack:** Docker 29.9.3, Docker Compose, GitHub Actions, Cloudflare CDN, Sentry, OpenTelemetry
> **Tags:** `chore`, `security`, `performance` (infra-related)
> **Quando dispatchar:** Cards com tags de infra, Docker, CI/CD, deploy, segurança

---

## Responsabilidades

| Domínio | O que faz |
|---------|-----------|
| **Docker** | Dockerfile, docker-compose.yml, multi-stage builds |
| **CI/CD** | GitHub Actions, pipelines, quality gates |
| **Deploy** | Kamal, staging/production, rollbacks |
| **Security** | Brakeman, Bundler Audit, CSP, CSRF, XSS |
| **Monitoring** | Sentry, OpenTelemetry, logs, metrics |

---

## Padrões de Infra

### Docker

```dockerfile
# Dockerfile
FROM ruby:4.0.9-slim AS base
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    postgresql-client \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy code
COPY . .

# Build assets
RUN bundle exec rake assets:precompile

# Run
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
```

### GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:18
        ports:
          - 5432:5432
      redis:
        image: redis:8
        ports:
          - 6379:6379
    steps:
      - uses: actions/checkout@v4
      - name: Run RSpec
        run: bundle exec rspec
```

### Kamal

```bash
# Deploy
kamal deploy --version latest

# Rollback
kamal rollback --version <previous>

# Healthcheck
kamal primary exec -- "bin/rails healthcheck"
```

---

## Convenções

| Aspecto | Regra |
|---------|-------|
| **Docker** | Multi-stage build, slim base, cache layers |
| **CI** | PostgreSQL + Redis services, parallel jobs |
| **Deploy** | Kamal, zero-downtime, healthcheck antes |
| **Rollback** | `kamal rollback --version <previous>` |
| **Env vars** | `.env.example` com todas as variáveis |
| **Secrets** | Nunca hardcode; usar env vars ou secret manager |
| **CSP** | Strict CSP, nonce-based, no inline scripts |

---

## Comandos de Validação

```bash
# Docker
docker compose up -d
docker compose logs -f
docker compose down

# CI local
bundle exec rspec
bundle exec brakeman -Z .brakeman/brakeman.yml
bundle exec bundler-audit update

# Healthcheck
curl http://localhost:3000/healthcheck

# Kamal
kamal version
kamal locks
```

---

## Anti-Patterns

| Anti-pattern | Sintoma | Previna por |
|--------------|---------|-------------|
| **Hardcoded secrets** | API keys no código | Env vars, `.env.example` |
| **No healthcheck** | Deploy sem verificação | Kamal healthcheck antes de swap |
| **No rollback** | Deploy sem rollback plan | Kamal locks, version tracking |
| **CI sem parallel** | Jobs sequenciais lentos | Parallel jobs, services em parallel |
| **Docker layer cache** | Build lento, sem cache | Multi-stage, cache layers |

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
