# FABLE.md — Carva Agent Protocol

> **O que é:** Adaptação do Fable Method (Sahir619/fable-method) para o Carva.
> **Objetivo:** Eliminar alucinação, retry thrash e verification theater.
> **Onde vive:** `Carva/FABLE.md` — lido por TODOS os agentes (leader + subagents).
> **Licença:** MIT (derivado de Sahir619/fable-method)

---

## 1. O Loop (resumo)

```
ask → classify → define done → evidence → decide → act → verify → report
```

Cada passo tem regras duras. O líder aplica o loop completo; subagents aplicam só os passos 4-5 (act + verify) sob supervisão.

---

## 2. Divisão de Responsabilidades

### 🧠 LÍDER (este agente, sempre)

| Passo | O que faz |
|-------|-----------|
| **0 - Classificar** | Classifica o ask (question/task/plan-first). Extrai constraints e decisões já tomadas. |
| **1 - Definir done** | Nomeia a verificação concreta (comando, teste, output). |
| **2 - Evidência** | Lê arquivos reais, roda comandos, paralleliza buscas. **Nunca inventa.** |
| **3 - Decidir** | Uma recomendação. Nomes alternativas e por que perderam. |
| **5 - Verificar** | Roda os testes/built. Confirma que o passo 1 passou. |
| **6 - Reportar** | Outcome-first, caveats honestos, artifact gate. |
| **Dispatch** | Cria cards Kanban, move para IN_PROGRESS, dispatcha subagentes, revisa output. |

### 🔨 SUBAGENTE (especialista por engine)

| Passo | O que faz |
|-------|-----------|
| **4 - Agir** | Implementa o código sob escopo declarado. Segue o intent gate. |
| **5(a) - Verificar** | Roda o teste/comando específico. Mostra output real. |
| **Report** | Entrega o que fez, o que rodou, e o que falhou (se falhou). |

**O que subagentes NÃO fazem:**
- ❌ Decidir arquitetura ou stack
- ❌ Criar/mover cards Kanban
- ❌ Dispatchar outros subagents
- ❌ Tomar decisões fora do escopo do card
- ❌ Commitar código

---

## 3. Anti-Hallucination Guards (OBRIGATÓRIO)

### Guard 1 — Recall Gate (antes de USAR qualquer coisa)

> **Nunca use um API, arquivo, ou path de memória.** Antes de primeiro uso, abra a fonte real.

```
RECALL CHECK:
  - [ ] Abri o arquivo fonte antes de usar?
  - [ ] Se não abri: PARAR e abrir agora.
```

### Guard 2 — Intent Gate (antes de MUDAR comportamento)

> **Antes de qualquer edição comportamental, escrever:**

```
INTENT: code does <X>; the task expects <Y>; the spec says <Z>
```

Se X, Y, Z não concordam → **não editar ainda**. Superficiar a contradição.

### Guard 3 — Verification Theater (antes de dizer "passou")

> **"Deve funcionar" não é verificação. Verificação é observar.**

```
VERIFICATION CHECK:
  - [ ] Rodou o comando? (não "deve rodar")
  - [ ] Viu o output? (não "deve mostrar")
  - [ ] O output confere com o esperado?
```

### Guard 4 — Twin Check (quando corrigir um bug)

> **Um bug num lugar = bug em outros até prova em contrário.**

```
TWINS: searched <pattern> - found <N> other sites: <files or "none">
```

### Guard 5 — Hard Bound (retry thrash)

> **3 ciclos de falha = parar e hand-back.**

```
RETRY CHECK:
  - Tentativa 1: falhou → ajustar → tentar 2
  - Tentativa 2: falhou → ajustar → tentar 3
  - Tentativa 3: falhou → PARAR. Reportar output e hipótese.
```

---

## 4. Failure Modes do Carva (adaptados)

| # | Modo | Sintoma | Previne por |
|---|------|---------|-------------|
| 1 | **Inventar arquivos** | Subagente cria código para arquivo que não existe | Guard 1 (Recall Gate) |
| 2 | **Loop infinito de debug** | "Deixa eu debugar" → "deixa eu debugar" → ... | Guard 5 (Hard Bound: 2 loops de debug = parar) |
| 3 | **Verificação falsa** | "Testes passaram" sem rodar | Guard 3 (Verification Theater) |
| 4 | **Scope creep** | Subagente refatora código não solicitado | Leader define escopo no card; subagente segue |
| 5 | **Skip before_action falhando** | Rails não remove callback como esperado | Guard 2 (Intent Gate) + ler docs reais |
| 6 | **Costume rigor** | Agente parece rigoroso mas não verificou | Guard 3 + Guard 4 |

---

## 5. Protocolo de Dispatch (Líder → Subagent)

### Antes de dispatchar:

1. **Criar card Kanban** em `TODO/` com frontmatter completo
2. **Mover para `IN_PROGRESS/`**
3. **Escrever prompt do subagent** com:
   - Contexto do projeto (stack, paths, conventions)
   - O que implementar (passo a passo)
   - Arquivos a criar/modificar (com caminhos EXATOS)
   - Comandos de validação (com output esperado)
   - Regras duras (namespace, naming, etc.)

### Ao receber output do subagent:

1. **Ler os arquivos criados** (não confiar no resumo)
2. **Rodar os comandos de validação** (não confiar no subagent)
3. **Se falhar:** corrigir diretamente OU dispatchar de volta com diagnóstico
4. **Se passar:** mover card para `DONE/`, atualizar README

---

## 6. Exemplo Real (T-009 Sessions Controller)

### O que aconteceu (falha):
```
Subagent: "Deixa eu debugar" → shell
Subagent: "Deixa eu debugar" → shell
Subagent: "Deixa eu debugar" → shell
(Subagent preso em loop, nunca resolveu)
```

### Como o Fable Method previne:
```
Step 2: Orient first → ler arquivos reais (não assumir)
Step 2.5: Time-box → 2 rounds de lookup, depois parar
Guard 5: Hard bound → 3 tentativas máximas
Step 5: Verify by observation → rodar teste, ver output
```

### Correção correta (o que fiz):
```
1. Li o controller e o teste (evidência real)
2. Identifiquei: teste usa HTTP_X_TENANT, controller usa HTTP_HOST
3. Corrigi o teste para passar o host correto
4. Rodé o teste → ainda falhando (403)
5. Identifiquei: skip_before_action não funciona como esperado
6. Sobrescrevi authenticate_request no SessionsController
7. Rodé o teste → ainda falhando (3ª tentativa)
8. PARAR. Reportar output e hipótese.
```

---

## 7. Checklist do Líder (antes de aprovar)

- [ ] Card Kanban criado com frontmatter completo?
- [ ] Subagent recebeu escopo EXATO (arquivos, paths, comandos)?
- [ ] Li os arquivos criados (não confiei no resumo)?
- [ ] Rodé os comandos de validação (não confiei no subagent)?
- [ ] Se falhou: corrigi diretamente OU dispatchei com diagnóstico?
- [ ] Se passou: movi card para DONE, atualizei README?
- [ ] Report outcome-first com caveats honestos?

---

## 8. Skills Instaladas

O projeto mantém 4 skills Fable Method em `skills/`:

| Skill | Comando | Quando usar |
|-------|---------|-------------|
| **fable-method** | `/fable-method <task>` | Sempre ao iniciar tarefa multi-step |
| **fable-judge** | `/fable-judge` | Após subagent dizer "trabalho completo" |
| **fable-loop** | `/fable-loop <task>` | Tarefas com 3+ passos heterogêneos |
| **fable-domain** | `/fable-domain <sector>` | Raramente — só novos domínios não-coding |

### Como Carregar

As skills são lidas automaticamente pelo agente. Para verificar:

```bash
ls skills/fable-method/SKILL.md
ls skills/fable-judge/SKILL.md
ls skills/fable-loop/SKILL.md
ls skills/fable-domain/SKILL.md
```

## 9. Comandos Rápidos

```bash
# Rails
bin/rails db:migrate          # aplicar migrations
bin/rails db:migrate:status   # status das migrations
bin/rails routes              # rotas

# Testes
bundle exec rspec <path>      # rodar specs específicos
bundle exec rspec             # rodar todos

# Docker
docker compose up -d          # subir serviços
docker compose logs -f        # logs em tempo real

# Healthcheck
curl http://localhost:3000/healthcheck
```

---

*Derivado de https://github.com/Sahir619/fable-method (MIT)*
*Adaptado para Carva por líder em 2025-01-01*
