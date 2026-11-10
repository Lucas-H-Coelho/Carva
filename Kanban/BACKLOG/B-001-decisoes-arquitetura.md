---
id: B-001
phase: Fase 0
priority: P0
status: backlog
depends: none
---

# B-001 — Decisões de arquitetura pendentes

## Descrição

Itens que precisam de decisão humana antes de podermos prosseguir com a implementação.

---

## Itens

### B-001.1 — Multi-tenancy: subdomínio vs path vs header

| Aspecto | Subdomínio | Path | Header |
|---------|-----------|------|--------|
| UX | `tenant.carva.com` | `carva.com/tenant` | `X-Tenant-ID` |
| SEO | Excelente | Ruim | Não aplica |
| Impl | Complexo | Simples | Simples |
| CDN | Fácil | Difícil | Difícil |

**Recomendação:** Subdomínio para tenants, path para API interna.

**Decisões necessárias:**
- [ ] Qual estratégia principal?
- [ ] Como lidar com tenants sem subdomínio?
- [ ] Como resolver tenants com domain customizado?

---

### B-001.2 — API versioning

| Estratégia | Prós | Contras |
|------------|------|---------|
| URL (`/api/v1/`) | Explícito, versionável | URL longa |
| Header (`X-API-Version`) | URL limpa | Harder to cache |
| Accept header | RESTful | Harder to debug |

**Recomendação:** URL versioning (`/api/v1/`, `/api/v2/`).

**Decisões necessárias:**
- [ ] Qual estratégia?
- [ ] Qual version? (v1, v2, v3)
- [ ] Política de depreciação?

---

### B-001.3 — Theme engine: Liquid fork vs upstream

| Opção | Prós | Contras |
|-------|------|---------|
| Fork interno | Controle total, customizações | Manter fork, bugs próprios |
| Upstream | Atualizações automáticas, comunidade | Sem customizações, dependência externa |
| Fork mínimo | Equilíbrio | Ainda mantém fork |

**Recomendação:** Fork mínimo do Liquid upstream.

**Decisões necessárias:**
- [ ] Fork ou upstream?
- [ ] Quais customizações de Liquid?
- [ ] Quem mantém o fork?

---

## Próximos passos

1. Agendar reunião de alinhamento com stakeholder
2. Documentar decisões em `ARCHITECTURE.md`
3. Criar cards de implementação no TODO
