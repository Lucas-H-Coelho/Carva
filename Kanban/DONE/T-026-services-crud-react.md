---
id: T-026
phase: Fase 1
priority: P0
status: done
depends: T-013, T-044
tags: [feature, carva_inventory, carva_dashboard, full-stack]
---

# T-026 — Services CRUD + React

## Objetivo

Implementar CRUD completo de serviços (backend + frontend React) para o dashboard admin.

## Contexto

- Model já existe em `app/engines/carva_inventory/app/models/carva/inventory/service.rb`
- Migration já existe em `db/migrate/20250101000003_create_services.rb`
- Storefront API tem apenas `index` (público, serviços ativos)
- Factory existe em `spec/factories/inventory.rb`
- Specs existentes: model spec (10 exemplos), controller spec (6 exemplos)

## O que implementar

### Backend

1. **Admin API Controller** — `app/api/v1/admin/services_controller.rb`
   - `index` — listar todos os serviços do tenant (com paginação)
   - `show` — mostrar serviço específico
   - `create` — criar serviço
   - `update` — atualizar serviço
   - `destroy` — deletar serviço
   - `toggle_active` — ativar/desativar serviço

2. **Service Objects** — `app/services/carva_inventory/`
   - `CreateService` — criar novo serviço
   - `UpdateService` — atualizar serviço
   - `DeleteService` — deletar serviço

3. **Form Object** — `app/forms/carva_inventory/service_form.rb`
   - Validação via ActiveModel::Validations
   - Persistência delegada ao Service Object

4. **Policy** — `app/policies/carva_dashboard/service_policy.rb`
   - Pundit para autorização
   - Métodos: index?, show?, create?, update?, destroy?, toggle_active?

5. **Routes** — adicionar rotas admin em `config/routes.rb`
   - `resources :services, module: :admin`

6. **Tests**
   - Controller spec para admin API
   - Service specs
   - Form spec
   - Policy spec

### Frontend

1. **Zustand Store** — `frontend/dashboard/src/stores/servicesStore.ts`
   - Estado: services, selectedService, loading, error
   - Actions: fetchServices, createService, updateService, deleteService, toggleActive

2. **API Client** — `frontend/dashboard/src/api/services.ts`
   - Funções: list, create, update, destroy, toggleActive
   - Integração com API backend

3. **React Components** — `frontend/dashboard/src/components/Services/`
   - `ServicesList` — tabela com lista de serviços
   - `ServiceForm` — formulário com React Hook Form + Zod
   - `ServiceDetail` — detalhes do serviço
   - `ServiceToggle` — toggle de ativo/inativo

4. **Routing** — atualizar `frontend/dashboard/src/main.tsx`
   - Rota `/services` com lazy loading

## Arquivos a criar

### Backend
- `app/api/v1/admin/services_controller.rb`
- `app/services/carva_inventory/create_service.rb`
- `app/services/carva_inventory/update_service.rb`
- `app/services/carva_inventory/delete_service.rb`
- `app/forms/carva_inventory/service_form.rb`
- `app/policies/carva_dashboard/service_policy.rb`
- `spec/api/v1/admin/services_controller_spec.rb`
- `spec/services/carva_inventory/create_service_spec.rb`
- `spec/services/carva_inventory/update_service_spec.rb`
- `spec/services/carva_inventory/delete_service_spec.rb`
- `spec/forms/carva_inventory/service_form_spec.rb`
- `spec/policies/carva_dashboard/service_policy_spec.rb`

### Frontend
- `frontend/dashboard/src/stores/servicesStore.ts`
- `frontend/dashboard/src/api/services.ts`
- `frontend/dashboard/src/components/Services/ServicesList.tsx`
- `frontend/dashboard/src/components/Services/ServiceForm.tsx`
- `frontend/dashboard/src/components/Services/ServiceDetail.tsx`
- `frontend/dashboard/src/components/Services/ServiceToggle.tsx`
- `frontend/dashboard/src/schemas/service.ts` (Zod schemas)

## Comandos de validação

```bash
# Backend
bundle exec rspec spec/api/v1/admin/services_controller_spec.rb
bundle exec rspec spec/services/
bundle exec rspec spec/forms/
bundle exec rspec spec/policies/

# Frontend
cd frontend/dashboard && npm run build
```

## Regras duras

- Namespace: `Carva::Inventory::` para models/services
- Naming: snake_case, plural tables
- JSON:API response format (usar `render_json_api` e `render_json_api_collection`)
- Multi-tenancy: todos os queries scoped por `tenant_id`
- Não refatorar código não solicitado
- Zod schemas para validação frontend
- React Hook Form para formulários
- WCAG 2.1 AA mínimo para acessibilidade

## Regras de leitura obrigatória

- LEIA `agents/profiles/backend.md` ANTES de começar backend
- LEIA `agents/profiles/frontend.md` ANTES de começar frontend
- LEIA `AGENT.md` para entender o contexto do projeto
- LEIA `agents/dispatch.md` para entender o protocolo de dispatch
- NÃO assuma que arquivos existem — verifique com `ls` ou `cat`
- NÃO comite código — só o líder comita
- NÃO dispatcha outros subagentes — você é folha
