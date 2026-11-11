---
id: B-001
phase: Fase 0
priority: P0
status: done
depends: none
tags: [docs, carva_core, blocking]
resolved: 2026-01-10
---

# B-001 — Decisões de arquitetura (RESOLVIDO)

## Decisões Documentadas

### B-001.1 — Multi-tenancy: subdomínio ✅

**Decisão:** Subdomínio para tenants (`tenant.carva.com`), path para API interna (`/api/v1/`).

**Documentado em:** `ARCHITECTURE.md` §3, `AGENT.md` §5

### B-001.2 — API versioning: URL-based ✅

**Decisão:** URL versioning (`/api/v1/`, `/api/v2/`). Depreciação com 6 meses de aviso via headers.

**Documentado em:** `ARCHITECTURE.md` §5.2, `AGENT.md` §7

### B-001.3 — Theme engine: fork mínimo ✅

**Decisão:** Fork mínimo do Liquid upstream. Customizações: tenant context, schema validation, React hydration hooks.

**Documentado em:** `ARCHITECTURE.md` §10.2, `THEME_SYSTEM.md`

---

*Resolvido em 2026-01-10. Decisões documentadas e validadas.*
