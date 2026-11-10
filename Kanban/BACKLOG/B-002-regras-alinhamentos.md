---
id: B-002
phase: Fase 0
priority: P1
status: backlog
depends: B-001
---

# B-002 — Regras e alinhamentos pendentes

## Descrição

Regras de desenvolvimento, convenções de código e alinhamentos que precisam ser definidos antes de começar a implementar.

---

## Itens

### B-002.1 — Convenções de commit

| Aspecto | Opção |
|---------|-------|
| Format | Conventional Commits |
| Prefixes | `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `chore:`, `ci:`, `revert:` |
| Scope | `(engine)`, `(theme)`, `(api)`, `(auth)`, etc. |
| Breaking | `BREAKING CHANGE:` no footer |

**Decisões necessárias:**
- [ ] Adotar Conventional Commits?
- [ ] Quais scopes?
- [ ] Como lidar com merges?

---

### B-002.2 — Convenções de código Ruby

| Aspecto | Opção |
|---------|-------|
| Linter | RuboCop |
| Formatter | RuboCop AutoCorrect |
| Style | Rails Style Guide |
| Naming | snake_case, plural tables |

**Decisões necessárias:**
- [ ] Qual style guide?
- [ ] Quais regras RuboCop?
- [ ] Auto-correct ou manual?

---

### B-002.3 — Convenções de código JavaScript/React

| Aspecto | Opção |
|---------|-------|
| Linter | ESLint |
| Formatter | Prettier |
| Naming | camelCase, PascalCase components |
| Hooks | Custom hooks em `@/hooks` |
| Components | Functional components only |

**Decisões necessárias:**
- [ ] Quais regras ESLint?
- [ ] Estrutura de pastas frontend?
- [ ] Naming conventions?

---

### B-002.4 — Testes

| Aspecto | Opção |
|---------|-------|
| Framework | RSpec |
| Mock | RSpec mocks |
| Factory | FactoryBot |
| Coverage | SimpleCov |
| Parallel | parallel_tests |

**Decisões necessárias:**
- [ ] Cobertura mínima? (80%? 90%?)
- [ ] System tests? (Capybara?)
- [ ] Contract tests? (WebMock?)

---

### B-002.5 — Deploy e ambientes

| Aspecto | Opção |
|---------|-------|
| Environments | dev, staging, production |
| Deploy | Manual (workflow_dispatch) |
| Environments | GitHub Environments |
| Secrets | GitHub Secrets |

**Decisões necessárias:**
- [ ] Quantos ambientes?
- [ ] Deploy automático ou manual?
- [ ] Quem pode deployar?

---

## Próximos passos

1. Definir convenções de commit
2. Definir convenções de código Ruby
3. Definir convenções de código JavaScript
4. Definir cobertura mínima de testes
5. Definir estratégia de deploy
6. Documentar tudo em `AGENT.md`
