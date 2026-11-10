---
id: T-003
phase: Fase 0
priority: P0
status: todo
depends: none
---

# T-003 — GitHub Actions CI/CD pipeline

## Descrição

Configurar pipeline CI/CD com GitHub Actions para rodar testes, linting e auditorias de segurança em cada push/PR.

## Escopo

- Workflow `ci.yml` com jobs:
  - `setup` (Ruby, Node.js, PostgreSQL, Redis)
  - `lint` (RuboCop, ESLint)
  - `test` (RSpec, system tests)
  - `security` (Brakeman, bundler-audit)
- Branch protection rules
- Status checks obrigatórios para merge

## Acceptance Criteria

- [ ] `.github/workflows/ci.yml` criado
- [ ] Workflow roda em push para `main` e `develop`
- - [ ] Jobs: setup, lint, test, security
- [ ] PostgreSQL + Redis como services no CI
- [ ] `rubocop` passa com zero warnings
- [ ] `brakeman` passa com zero vulnerabilities
- [ ] `bundler-audit` atualizado

## Implementation Notes

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
      redis:
        image: redis:7-alpine
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
      - run: bundle install
      - run: bundle exec rspec
```

## Dependencies

- Fase 0 (setup inicial)
