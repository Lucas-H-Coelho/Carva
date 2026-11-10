# Requisitos Consolidados — Carva SaaS

> **Fonte:** 4 stakeholders pesquisados (S1-S4)
> **Data:** 2025-01-01
> **Status:** Consolidado, pronto para Fase 2

---

## 1. Personas

| # | Persona | Nome | Escopo | Dispositivo | Dor Principal |
|---|---------|------|--------|-------------|---------------|
| **S1** | Dono do Lava-Carro | Carlos Eduardo, 42 | 1 unidade (LavaBravas) | Celular Android (Galaxy A14) | Não sabe quanto entrou, não sabe quantos carros faltam, não sabe se acabou o shampoo |
| **S2** | Cliente Final | Ricardo Mendes, 32 | Pessoa que usa o serviço | Celular iPhone 14 | Não consegue agendar sem ligar, não sabe se o carro está pronto |
| **S3** | Funcionário | José Antônio, 34 | Operador / "chefe de serviço" | Celular Android barato (Redmi 9A) | Não sabe quem lava qual carro, não sabe se o cliente pagou, não tem visão do dia |
| **S4** | Gerente Multi-tenant | Ana Paula, 48 | 5 unidades (AutoLava) | Celular + iPad + notebook | Não vê desempenho por unidade, perde 2h/semana compilando planilhas, estoque descontrolado |

---

## 2. User Stories Consolidadas

### 2.1 Agendamento (S2 → S1/S3)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-001 | Como cliente, quero agendar um serviço online sem ligar | S2 | P0 |
| US-002 | Como cliente, quero ver os horários disponíveis antes de agendar | S2 | P0 |
| US-003 | Como cliente, quero receber confirmação por WhatsApp | S2 | P0 |
| US-004 | Como cliente, quero receber aviso quando o carro estiver pronto | S2 | P0 |
| US-005 | Como dono, quero ver todos os agendamentos do dia | S1 | P0 |
| US-006 | Como funcionário, quero ver a lista de carros do dia | S3 | P0 |
| US-007 | Como funcionário, quero marcar "comecei" e "finalizei" no serviço | S3 | P0 |
| US-008 | Como dono, quero ver o status de cada serviço em tempo real | S1 | P0 |
| US-009 | Como funcionário, quero criar atendimento walk-in (sem agendamento) | S3 | P0 |
| US-010 | Como dono, quero ver quantos carros faltam lavar | S1 | P0 |

### 2.2 Pagamento (S1/S2/S3)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-011 | Como cliente, quero pagar rápido via PIX | S2 | P0 |
| US-012 | Como funcionário, quero registrar pagamento (PIX, dinheiro, cartão) | S3 | P0 |
| US-013 | Como funcionário, quero saber se o cliente já pagou | S3 | P0 |
| US-014 | Como dono, quero ver o fluxo de caixa do dia | S1 | P0 |
| US-015 | Como gerente multi-tenant, quero ver fluxo de caixa por unidade | S4 | P0 |
| US-016 | Como dono, quero ver minha comissão por funcionário | S1 | P0 |
| US-017 | Como funcionário, quero ver minha comissão mensal | S3 | P0 |

### 2.3 Estoque (S1/S3/S4)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-018 | Como funcionário, quero reportar estoque baixo | S3 | P0 |
| US-019 | Como dono, quero ver quais produtos estão acabando | S1 | P0 |
| US-020 | Como gerente multi-tenant, quero ver estoque consolidado de todas as unidades | S4 | P0 |
| US-021 | Como gerente multi-tenant, quero transferir estoque entre unidades | S4 | P0 |
| US-022 | Como dono, quero definir nível mínimo de alerta por produto | S1 | P1 |

### 2.4 Equipe (S1/S3/S4)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-023 | Como funcionário "chefe de serviço", quero distribuir carros entre funcionários | S3 | P0 |
| US-024 | Como funcionário, quero ver quem lava qual carro | S3 | P0 |
| US-025 | Como gerente multi-tenant, quero ver equipe por unidade | S4 | P0 |
| US-026 | Como gerente multi-tenant, quero emprestar funcionário entre unidades | S4 | P1 |
| US-027 | Como dono, quero ver quantos funcionários faltaram hoje | S1 | P1 |

### 2.5 Relatórios (S1/S4)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-028 | Como dono, quero ver resumo do dia (carros lavados, faturamento, comissão) | S1 | P0 |
| US-029 | Como gerente multi-tenant, quero dashboard consolidado de todas as unidades | S4 | P0 |
| US-030 | Como gerente multi-tenant, quero comparar faturamento entre unidades | S4 | P0 |
| US-031 | Como gerente multi-tenant, quero ver lucro bruto por unidade | S4 | P0 |
| US-032 | Como dono, quero exportar relatório mensal em PDF/Excel | S1 | P1 |
| US-033 | Como gerente multi-tenant, quero exportar relatório consolidado | S4 | P1 |
| US-034 | Como gerente multi-tenant, quero ver ranking de unidades | S4 | P1 |

### 2.6 Notificações (S1/S2/S3/S4)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-035 | Como cliente, quero receber aviso de agendamento confirmado | S2 | P0 |
| US-036 | Como cliente, quero receber aviso quando o carro estiver pronto | S2 | P0 |
| US-037 | Como dono, quero receber alerta de estoque baixo | S1 | P0 |
| US-038 | Como gerente multi-tenant, quero receber alerta por unidade | S4 | P0 |
| US-039 | Como funcionário, quero receber notificação de novo agendamento | S3 | P1 |

### 2.7 Cadastro e Onboarding (S1/S2/S4)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-040 | Como dono, quero me cadastrar e configurar o sistema em menos de 15 minutos | S1 | P0 |
| US-041 | Como cliente, quero me cadastrar com WhatsApp e pagar sem senha | S2 | P0 |
| US-042 | Como gerente multi-tenant, quero cadastrar unidades e gerentes em menos de 24 minutos | S4 | P0 |
| US-043 | Como funcionário, quero acessar sem senha, só com número de WhatsApp vinculado | S3 | P0 |

### 2.8 Qualidade e Fidelização (S1/S2)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-044 | Como cliente, quero avaliar o serviço após receber o carro | S2 | P1 |
| US-045 | Como dono, quero ver nota média de avaliação por serviço | S1 | P1 |
| US-046 | Como dono, quero ver clientes mais frequentes | S1 | P1 |
| US-047 | Como cliente, quero receber lembrete antes do agendamento | S2 | P1 |

### 2.9 Funcionalidades Avançadas (S3/S4)

| ID | Story | Stakeholders | Prioridade |
|----|-------|--------------|------------|
| US-048 | Como funcionário, quero tirar foto do carro antes/depois | S3 | P2 |
| US-049 | Como funcionário, quero registrar dano no carro | S3 | P2 |
| US-050 | Como funcionário, quero trabalhar sem internet (modo offline) | S3 | P2 |
| US-051 | Como gerente multi-tenant, quero ver gráfico de crescimento por unidade | S4 | P2 |
| US-052 | Como gerente multi-tenant, quero definir meta de faturamento por unidade | S4 | P2 |
| US-053 | Como gerente multi-tenant, quero ver previsão de demanda | S4 | P2 |

---

## 3. Funcionalidades por Prioridade

### P0 — MVP (essencial para lançar)

| # | Funcionalidade | Stakeholders | Engine |
|---|----------------|--------------|--------|
| 1 | Sistema de agendamento online (cliente) | S2 | carva_storefront |
| 2 | Lista de agendamentos do dia (donos/funcionários) | S1, S3 | carva_storefront |
| 3 | Marcar status do serviço (comecei/terminei) | S3 | carva_storefront |
| 4 | Registro de pagamento (PIX, dinheiro, cartão) | S2, S3, S1 | carva_billing |
| 5 | Fluxo de caixa do dia | S1 | carva_billing |
| 6 | Reportar estoque baixo | S3, S1 | carva_inventory |
| 7 | Dashboard do dia (donos) | S1 | carva_dashboard |
| 8 | Dashboard consolidado (multi-tenant) | S4 | carva_dashboard |
| 9 | Comparativo entre unidades | S4 | carva_dashboard |
| 10 | Notificações por WhatsApp | S2, S1, S4 | carva_marketing |
| 11 | Cadastro rápido (donos, clientes, funcionários) | S1, S2, S3, S4 | carva_core |
| 12 | Auth com WhatsApp (sem senha) | S2, S3 | carva_core |

### P1 — Importante para reter usuários

| # | Funcionalidade | Stakeholders | Engine |
|---|----------------|--------------|--------|
| 13 | Exportar relatório mensal (PDF/Excel) | S1, S4 | carva_dashboard |
| 14 | Transferir estoque entre unidades | S4 | carva_inventory |
| 15 | Distribuir carros entre funcionários | S3 | carva_storefront |
| 16 | Ver comissão por funcionário | S1, S3 | carva_billing |
| 17 | Ver lucro bruto por unidade | S4 | carva_billing |
| 18 | Avaliar serviço (estrelas) | S2, S1 | carva_storefront |
| 19 | Lembrete de agendamento | S2 | carva_marketing |
| 20 | Ver clientes mais frequentes | S1 | carva_marketing |
| 21 | Definir preços por unidade | S4 | carva_storefront |
| 22 | Gerenciar permissões | S4 | carva_core |

### P2 — Diferencial competitivo

| # | Funcionalidade | Stakeholders | Engine |
|---|----------------|--------------|--------|
| 23 | Foto antes/depois do carro | S3 | carva_storefront |
| 24 | Registrar dano no carro | S3 | carva_storefront |
| 25 | Modo offline | S3 | carva_storefront |
| 26 | Gráfico de crescimento por unidade | S4 | carva_dashboard |
| 27 | Meta de faturamento por unidade | S4 | carva_dashboard |
| 28 | Previsão de demanda | S4 | carva_dashboard |
| 29 | Ranking de gerentes | S4 | carva_dashboard |
| 30 | Campanha por unidade | S4 | carva_marketing |

---

## 4. Requisitos Técnicos Derivados

### 4.1 Multi-tenancy

- **Subdomain strategy:** `tenant.carva.com`
- **Isolamento de dados:** todas as queries filtradas por `tenant_id`
- **Permissões:** S1 vê só sua unidade, S4 vê todas + consolidado
- **Middleware:** `TenantMiddleware` injeta `Carva::Current.tenant` antes de cada request

### 4.2 Autenticação

- **Dono:** email + senha (Devise) ou WhatsApp (OTP)
- **Cliente:** WhatsApp (telefone) — sem senha, link mágico
- **Funcionário:** WhatsApp vinculado pelo dono — sem senha
- **API Key:** `X-Carva-API-Key` header para clientes externos

### 4.3 Notificações

- **Canal principal:** WhatsApp (API ou webhook)
- **Tipos:** agendamento confirmado, carro pronto, estoque baixo, alerta por unidade
- **Template:** mensagens pré-definidas, personalizáveis por dono

### 4.4 Exportação

- **Formatos:** PDF, Excel (.xlsx)
- **Escopo:** por unidade ou consolidado
- **Agendamento:** relatório semanal/mensal automático por email

### 4.5 Offline Mode

- **Storage local:** IndexedDB no navegador (PWA)
- **Sincronização:** automática quando internet voltar
- **Conflitos:** último write wins, com log de auditoria

---

## 5. Mapeamento Stakeholder → Engine

| Engine | Funcionalidades | Stakeholders Impactados |
|--------|----------------|------------------------|
| **carva_core** | Auth, multi-tenancy, permissões, config | S1, S2, S3, S4 |
| **carva_storefront** | Agendamento, status, walk-in, avaliação | S2, S3 |
| **carva_billing** | Pagamento, fluxo de caixa, comissão, lucro | S1, S2, S3, S4 |
| **carva_inventory** | Estoque, transferências, alertas | S1, S3, S4 |
| **carva_marketing** | Notificações WhatsApp, campanhas, lembretes | S1, S2, S4 |
| **carva_dashboard** | Dashboard, relatórios, gráficos, ranking | S1, S4 |
| **carva_theme_engine** | Tema visual, branding por unidade | S1, S4 |
| **carva_payments** | Gateway PIX, cartão, integração bancária | S2, S4 |

---

## 6. Fluxo de Implementação Sugerido

### Fase 2 — Core Features (MVP)

| Ordem | Card | Engine | Depende de |
|-------|------|--------|------------|
| 1 | T-013 | carva_core | T-012 (DONE) |
| 2 | T-014 | carva_storefront | T-013 |
| 3 | T-015 | carva_billing | T-013 |
| 4 | T-016 | carva_inventory | T-013 |
| 5 | T-017 | carva_marketing | T-014 |
| 6 | T-018 | carva_dashboard | T-015, T-016 |
| 7 | T-019 | carva_theme_engine | T-018 |
| 8 | T-020 | carva_payments | T-015 |

### Fase 3 — Retention & Growth

| Ordem | Card | Engine | Depende de |
|-------|------|--------|------------|
| 1 | T-021 | carva_dashboard | T-018 |
| 2 | T-022 | carva_marketing | T-017 |
| 3 | T-023 | carva_storefront | T-014 |
| 4 | T-024 | carva_inventory | T-016 |

### Fase 4 — Advanced Features

| Ordem | Card | Engine | Depende de |
|-------|------|--------|------------|
| 1 | T-025 | carva_dashboard | T-021 |
| 2 | T-026 | carva_storefront | T-023 |
| 3 | T-027 | carva_marketing | T-022 |

---

## 7. Métricas de Sucesso

| Métrica | Target | Stakeholder |
|---------|--------|-------------|
| Tempo para configurar o sistema | < 15 minutos | S1 |
| Tempo para agendar (sem ligar) | < 2 minutos | S2 |
| Tempo para marcar "comecei" | < 3 segundos | S3 |
| Tempo para ver dashboard consolidado | < 5 segundos | S4 |
| Taxa de no-show | < 10% | S1, S4 |
| Satisfação do cliente (nota) | > 4.5/5.0 | S2 |
| Retenção mensal de clientes | > 70% | S1 |

---

## 8. Glossário

| Termo | Definição |
|-------|-----------|
| **Tenant** | Unidade de lava-carro (ex: "LavaBravas Tatuapé") |
| **Dono** | Proprietário do tenant (S1) |
| **Gerente multi-tenant** | Proprietário de múltiplos tenants (S4) |
| **Funcionário** | Operador que lava os carros (S3) |
| **Cliente** | Pessoa que usa o serviço (S2) |
| **Walk-in** | Cliente que chega sem agendamento |
| **No-show** | Cliente que agendou e não apareceu |
| **Comissão** | Valor pago ao funcionário por carro lavado |
| **Fluxo de caixa** | Entradas e saídas financeiras do dia |
| **Estoque consolidado** | Soma de estoque de todas as unidades |
| **Transferência** | Mover produto de uma unidade para outra |

---

*Documento consolidado a partir de S1 (merchant-needs), S2 (customer-needs), S3 (employee-needs), S4 (manager-needs).*
