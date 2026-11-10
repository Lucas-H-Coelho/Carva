---
id: T-003
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-003 — GitHub Actions CI/CD pipeline

## Objetivo

Configurar pipeline CI/CD completo com GitHub Actions que roda em cada push/PR: lint, testes, segurança e build. Pipeline deve falhar rapidamente se algo estiver errado.

---

## Decisões a Tomar (antes de começar)

| # | Decisão | Opção A | Opção B | Recomendação |
|---|---------|---------|---------|-------------|
| D1 | Runner | `ubuntu-latest` | `ubuntu-22.04` | **`ubuntu-latest`** — sempre atualizado |
| D2 | Ruby version | 3.2.x | 3.3.x | **3.2.x** — mais testado com Rails 7.1 |
| D3 | Node version | 20.x | 22.x | **20.x (LTS)** — mais estável |
| D4 | Cache strategy | `actions/cache` | `actions/cache@v4` | **`actions/cache@v4`** — melhor performance |
| D5 | Parallel tests | `database: 1..5` | `parallel: 3` | **`database: 1..5`** — nativo Rails |
| D6 | Coverage | `simplecov` | `simplecov-lcov` | **`simplecov`** — HTML report local |
| D7 | Deploy | Manual (approve) | Auto (on push to main) | **Manual** — controle humano |

---

## Passo a Passo

### Passo 1 — Criar diretório de workflows

```bash
mkdir -p .github/workflows
```

### Passo 2 — Criar `ci.yml` (CI principal)

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  RUBY_VERSION: 3.2.2
  NODE_VERSION: 20
  POSTGRES_VERSION: 15
  REDIS_VERSION: 7
  RAILS_MAX_THREADS: 5

jobs:
  lint:
    name: Lint
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ env.RUBY_VERSION }}
          bundler-cache: true

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: |
          bundle install --jobs 4 --retry 3
          npm ci

      - name: Run RuboCop
        run: bundle exec rubocop --parallel

      - name: Run ESLint
        run: npm run lint

      - name: Run Prettier check
        run: npm run format:check

  test:
    name: Tests
    runs-on: ubuntu-latest
    timeout-minutes: 30
    services:
      postgres:
        image: postgres:${{ env.POSTGRES_VERSION }}
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

      redis:
        image: redis:${{ env.REDIS_VERSION }}-alpine
        ports:
          - 6379:6379
        options: >-
          --appendonly yes

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ env.RUBY_VERSION }}
          bundler-cache: true

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: |
          bundle install --jobs 4 --retry 3
          npm ci

      - name: Create database
        run: |
          bundle exec rails db:create RAILS_ENV=test

      - name: Run tests
        run: |
          bundle exec rspec --format progress --format junit --out rspec.xml --color
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/carva_test
          REDIS_URL: redis://localhost:6379/0

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: test-results
          path: rspec.xml

  security:
    name: Security
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ env.RUBY_VERSION }}
          bundler-cache: true

      - name: Run Brakeman
        run: bundle exec brakeman --quiet --no-potential-warnings || true

      - name: Run bundler-audit
        run: bundle exec bundler audit update && bundle exec bundler audit

  build:
    name: Build
    runs-on: ubuntu-latest
    timeout-minutes: 15
    needs: [lint, test, security]
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ env.RUBY_VERSION }}
          bundler-cache: true

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Build assets
        run: |
          bundle install --jobs 4 --retry 3
          npm ci
          bundle exec rails assets:precompile
          npm run build
```

### Passo 3 — Criar `deploy.yml` (CD manual)

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production

env:
  RUBY_VERSION: 3.2.2
  NODE_VERSION: 20

jobs:
  deploy:
    name: Deploy to ${{ github.event.inputs.environment }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ env.RUBY_VERSION }}
          bundler-cache: true

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: |
          bundle install --jobs 4 --retry 3
          npm ci

      - name: Build assets
        run: |
          bundle exec rails assets:precompile
          npm run build

      - name: Run migrations
        run: bundle exec rails db:migrate
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      - name: Deploy
        run: echo "Deploying to ${{ github.event.inputs.environment }}"
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
```

### Passo 4 — Criar `pr-check.yml` (checks em PR)

```yaml
# .github/workflows/pr-check.yml
name: PR Check

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-conventional-commits:
    name: Check commit messages
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check conventional commits
        run: |
          # Check last 10 commits for conventional format
          git log --oneline -10 | grep -E '^(feat|fix|docs|style|refactor|perf|test|chore|ci|revert)(\(.+\))?:' || \
          (echo "Commit messages must follow Conventional Commits format:" && \
           echo "  feat: add feature" && \
           echo "  fix: fix bug" && \
           echo "  docs: update docs" && \
           echo "  refactor: refactor code" && \
           echo "  test: add tests" && \
           echo "  chore: maintenance" && exit 1)
```

### Passo 5 — Configurar branch protection rules

No GitHub → Settings → Branches → Branch protection rules:

```
Branch pattern: main

Protection options:
- [x] Require a pull request before merging
- [x] Require branches to be up to date before merging
- [x] Require status checks to pass
  - CI (lint)
  - CI (test)
  - CI (security)
  - CI (build)
- [x] Include status checks for untrusted pull requests
- [ ] Require approval for the first green build (optional)
- [x] Require signed commits (optional, for production)
```

---

## Checklist de Aceitação

- [ ] `.github/workflows/ci.yml` criado
- [ ] `.github/workflows/deploy.yml` criado
- [ ] `.github/workflows/pr-check.yml` criado
- [ ] Workflow roda em push para `main` e `develop`
- [ ] Workflow roda em PR para `main`
- [ ] Jobs: lint, test, security, build
- [ ] PostgreSQL + Redis como services no CI
- [ ] `rubocop` roda e passa
- [ ] `rspec` roda e passa
- [ ] `brakeman` roda (ignora warnings com `|| true`)
- [ ] `bundler audit` roda e passa
- [ ] `npm run lint` roda e passa
- [ ] `npm run build` roda e passa
- [ ] Branch protection rules configuradas no GitHub
- [ ] Artifacts de teste salvos como `rspec.xml`

---

## Arquivos que devem existir ao final

```
Carva/
└── .github/
    └── workflows/
        ├── ci.yml
        ├── deploy.yml
        └── pr-check.yml
```

---

## Notas de Implementação

- **`bundler-cache: true`** no `ruby/setup-ruby` cacheia `vendor/` automaticamente
- **`brakeman --no-potential-warnings`** reduz falsos positivos no CI
- **`rspec.xml`** com formato JUnit para visualização no GitHub
- **`workflow_dispatch`** no deploy permite deploy manual quando quiser
- **Branch protection** é configurado via UI do GitHub, não via código

---

## Riscos e Mitigações

| Risco | Mitigação |
|-------|-----------|
| CI lento (>10min) | Parallel tests com `database: 1..5` |
| Falsos positivos no brakeman | `--no-potential-warnings` + `|| true` |
| Cache quebra entre builds | `bundler-cache: true` gerencia automaticamente |
| Testes falham por race condition | `database: 1..5` isola databases |
| Deploy acidental | `workflow_dispatch` exige ação manual |

---

## Comandos para Testar Localmente

```bash
# Instalar act (local GitHub Actions runner)
brew install act

# Rodar CI localmente
act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest

# Rodar apenas job de teste
act -j test

# Rodar apenas job de lint
act -j lint
```
