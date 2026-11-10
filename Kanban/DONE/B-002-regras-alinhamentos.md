---
id: B-002
phase: Fase 0
priority: P1
status: done
depends: B-001
tags: [docs, carva_core]
resolved: 2026-01-10
---

# B-002 — Regras e alinhamentos (RESOLVIDO)

## Regras Documentadas

### B-002.1 — Convenções de commit: Conventional Commits ✅

**Decisão:** Conventional Commits com scopes por engine.

**Documentado em:** `AGENT.md` §3, T-003 (pr-check.yml)

### B-002.2 — Convenções Ruby: RuboCop + Rails Guide ✅

**Decisão:** RuboCop com rubocop-rails, rubocop-rspec, rubocop-performance. Rails Style Guide.

**Documentado em:** `AGENT.md` §4, T-004, T-007

### B-002.3 — Convenções JS/React: ESLint + Prettier ✅

**Decisão:** ESLint + Prettier. camelCase, PascalCase components, functional only.

**Documentado em:** `AGENT.md` §2.2, T-005

### B-002.4 — Testes: RSpec + SimpleCov + parallel_tests ✅

**Decisão:** RSpec 6, FactoryBot, SimpleCov (cobertura 80%), parallel_tests (5 databases).

**Documentado em:** `AGENT.md` §4, T-004, T-007

### B-002.5 — Deploy: Manual via workflow_dispatch ✅

**Decisão:** Manual (workflow_dispatch). Ambientes: dev, staging, production.

**Documentado em:** `AGENT.md` §2.4, T-003 (deploy.yml)

---

*Resolvido em 2026-01-10. Regras documentadas e validadas.*
