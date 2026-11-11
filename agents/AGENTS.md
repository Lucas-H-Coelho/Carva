# Agents — Carva Agent Protocol

> **O que é:** Definição dos agentes, suas responsabilidades, e como operam em conjunto.
> **Onde vive:** `Carva/agents/AGENTS.md` — lido por TODOS os agentes no início de cada sessão.
> **Integração:** `agents/dispatch.md` (guia de dispatch) + `agents/profiles/*` (perfis) + `FABLE.md` (loop de trabalho)

---

## Visão Geral

```
┌─────────────────────────────────────────────────────────┐
│                    🧠 LÍDER (este agente)                │
│                                                         │
│  Classifica → Define done → Evidência → Decide          │
│  → Dispatch subagent → Verifica → Reporta               │
│                                                         │
│  Regra: feature-complete (backend + frontend + DB)      │
│  Regra: máximo 1 subagent por vez                       │
└────────────────────────┬────────────────────────────────┘
                         │ dispatch (1 por vez)
                         ▼
              ┌────────────────────┐
              │  🔨 SUBAGENTE      │
              │  (especialista)    │
              │                    │
              │  Age → Verifica    │
              │  → Reporta         │
              └────────────────────┘
```

### Princípios

1. **Feature-complete** — cada feature é desenvolvida end-to-end (backend + DB + frontend) antes de mover para DONE
2. **Líder decide, subagente executa** — subagentes não dispatcham outros, não criam cards Kanban, não commitam
3. **Máximo 1 subagente por vez** — nunca paralelizar subagentes; esperar um terminar antes de dispatchar o próximo
4. **Fable Method é o loop** — líder aplica o loop completo; subagentes aplicam só act + verify
5. **Zero pollution** — detalhes de debug ficam dentro da sessão do subagente; o líder só lê o resultado

---

## Estrutura

| Arquivo | Responsabilidade |
|---------|-----------------|
| `AGENTS.md` | Este arquivo — visão geral, divisão de papéis |
| `dispatch.md` | Guia detalhado de como dispatchar, validar, e aprovar subagentes |
| `profiles/backend.md` | Perfil do agente backend (Rails, APIs, DB, services) |
| `profiles/frontend.md` | Perfil do agente frontend (React, Vite, Liquid, storefronts) |
| `profiles/infra.md` | Perfil do agente infra (Docker, CI/CD, deploy, infra) |
| `profiles/qa.md` | Perfil do agente QA (testes, qualidade, validação) |

---

## Integração com FABLE.md

| Aspecto | Onde definido |
|---------|---------------|
| Loop completo (0-6) | `FABLE.md` — líder aplica todos os passos |
| Act + Verify (4-5) | `FABLE.md` — subagentes aplicam só estes |
| Anti-hallucination guards | `FABLE.md` — ambos seguem |
| Dispatch protocol | `agents/dispatch.md` — como o líder opera |
| Agent profiles | `agents/profiles/*` — stack e responsabilidades |

---

## Regras de Dispatch

1. **Um por vez** — nunca dispatchar mais de 1 subagente simultaneamente
2. **Escopo declarado** — cada subagente recebe: arquivos, paths, comandos de validação, regras duras
3. **Verificação real** — líder lê os arquivos criados e roda os comandos (não confia no resumo)
4. **Hard bound** — 3 tentativas de falha = parar e hand-back (Guard 5 do FABLE.md)
5. **Zero pollution** — detalhes de debug ficam dentro da sessão do subagente

---

## Checklist do Líder

- [ ] Card Kanban criado com frontmatter completo?
- [ ] Subagent recebeu escopo EXATO (arquivos, paths, comandos)?
- [ ] Li os arquivos criados (não confiei no resumo)?
- [ ] Rodé os comandos de validação (não confiei no subagent)?
- [ ] Se falhou: corrigi diretamente OU dispatchei com diagnóstico?
- [ ] Se passou: movi card para DONE, atualizei README?
- [ ] Report outcome-first com caveats honestos?

---

*Derivado do Fable Method (Sahir619/fable-method, MIT)*
*Adaptado para Carva por líder em 2025-01-01*
