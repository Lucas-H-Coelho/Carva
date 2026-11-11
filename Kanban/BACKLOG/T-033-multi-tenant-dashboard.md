---
id: T-033
phase: Fase 2
priority: P0
status: todo
depends: T-032, T-013
tags: [feature, carva_dashboard, blocking]
---

# T-033 — Dashboard consolidado multi-tenant (S4)

## Objetivo

Dashboard para o gerente multi-tenant (S4) ver todas as unidades em uma única tela: faturamento, agenda, equipe, estoque, alertas. Comparativo entre unidades, ranking, lucro bruto. Atende S4 (dashboard consolidado, comparar unidades, ver desempenho).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Query | `Tenant.joins` com `GROUP BY` para consolidar dados |
| D2 | Permissão | `role: :super_admin` vê todas as unidades, `role: :manager` vê só a sua |
| D3 | Alertas | `Alert` model com `tenant_id`, `type` (low_stock, low_revenue, low_rating) |
| D4 | Ranking | Query que ordena tenants por faturamento, satisfação, controle de estoque |
| D5 | Tempo real | Polling a cada 30s (não precisa WebSocket ainda) |

## Passo a Passo

### Passo 1 — Migration Alerts

```ruby
# db/migrate/20250101000020_create_alerts.rb
class CreateAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :alerts do |t|
      t.references :tenant, null: false, type: :bigint
      t.string :type, null: false # low_stock, low_revenue, low_rating, team_absence
      t.text :message
      t.jsonb :metadata, default: {}
      t.boolean :read, default: false
      t.datetime :dismissed_at

      t.timestamps
    end

    add_index :alerts, [:tenant_id, :type, :read]
  end
end
```

### Passo 2 — Service: MultiTenantDashboard

```ruby
# app/services/multi_tenant_dashboard_service.rb
class MultiTenantDashboardService
  def self.overview(super_admin)
    tenants = Tenant.where.not(status: 'closed')
    tenants.map do |tenant|
      {
        id: tenant.id,
        name: tenant.name,
        bookings_today: tenant.bookings.where(scheduled_at: Date.today).count,
        revenue_today: CashEntry.where(tenant: tenant, occurred_at: Date.today)
          .sum(:amount),
        revenue_week: CashEntry.where(tenant: tenant, occurred_at: Date.today.beginning_of_week..Date.today)
          .sum(:amount),
        revenue_month: CashEntry.where(tenant: tenant, occurred_at: Date.today.beginning_of_month..Date.today)
          .sum(:amount),
        gross_profit_month: CashEntry.where(tenant: tenant, occurred_at: Date.today.beginning_of_month..Date.today)
          .sum(:amount) - CashExit.where(tenant: tenant, occurred_at: Date.today.beginning_of_month..Date.today)
          .sum(:amount),
        low_stock_count: tenant.products.where('quantity <= min_quantity').count,
        low_rating: tenant.reviews.average(:rating) || 0,
        no_show_rate: calculate_no_show_rate(tenant),
        team_count: tenant.users.where.not(role: 'owner').count,
        alerts: tenant.alerts.where(read: false).count,
        status: tenant.status
      }
    end
  end

  def self.ranking(super_admin)
    overview(super_admin).sort_by { |t| t[:revenue_month] }.reverse
  end

  private
  def self.calculate_no_show_rate(tenant)
    total = tenant.bookings.where(scheduled_at: Date.today.beginning_of_month..Date.today).count
    noshow = tenant.bookings.where(status: 'cancelled', scheduled_at: Date.today.beginning_of_month..Date.today).count
    total > 0 ? (noshow.to_f / total * 100).round(1) : 0
  end
end
```

### Passo 3 — Controller: MultiTenantDashboard

```ruby
# app/controllers/api/v1/tenant_dashboard_controller.rb
module Api
  module V1
    class TenantDashboardController < ApplicationController
      skip_before_action :authenticate_request, only: [:overview]

      def overview
        render json: MultiTenantDashboardService.overview(Current.user)
      end

      def ranking
        render json: MultiTenantDashboardService.ranking(Current.user)
      end

      def unit_detail(tenant_id)
        tenant = Tenant.find(tenant_id)
        render json: {
          tenant: tenant.as_json,
          bookings: tenant.bookings.where(scheduled_at: Date.today),
          team: tenant.users.where.not(role: 'owner'),
          stock: tenant.products.where('quantity <= min_quantity'),
          alerts: tenant.alerts.where(read: false)
        }
      end
    end
  end
end
```

### Passo 4 — Alertas automáticos

```ruby
# app/workers/check_alerts_worker.rb
class CheckAlertsWorker
  def self.perform
    Tenant.all.each do |tenant|
      # Alerta de estoque baixo
      tenant.products.where('quantity <= min_quantity').each do |product|
        tenant.alerts.create!(
          type: 'low_stock',
          message: "#{product.name} está com estoque baixo (#{product.quantity} #{product.unit} restantes)",
          metadata: { product_id: product.id, quantity: product.quantity }
        )
      end

      # Alerta de faturamento baixo (vs média)
      avg_revenue = Tenant.average(:revenue_last_30_days)
      if tenant.revenue_last_30_days < avg_revenue * 0.7
        tenant.alerts.create!(
          type: 'low_revenue',
          message: "Faturamento abaixo da média (-30% vs média das unidades)"
        )
      end

      # Alerta de avaliação baixa
      if tenant.reviews.average(:rating) < 4.0
        tenant.alerts.create!(
          type: 'low_rating',
          message: "Avaliação média abaixo de 4.0 (#{tenant.reviews.average(:rating).round(1)})"
        )
      end
    end
  end
end
```

## Checklist

- [ ] Migration `create_alerts` roda com sucesso
- [ ] `MultiTenantDashboardService.overview` retorna dados de todos os tenants
- [ ] `MultiTenantDashboardService.ranking` ordena por faturamento
- [ ] `TenantDashboardController#overview` retorna JSON consolidado
- [ ] `TenantDashboardController#unit_detail` retorna detalhes de uma unidade
- [ ] `CheckAlertsWorker` cria alertas automáticos (estoque, receita, avaliação)
- [ ] Alertas são lidos/despistados pelo gerente
- [ ] Testes RSpec: dashboard service, controller, worker
- [ ] API retorna dados corretos para super_admin vs manager

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Query lenta com muitos tenants | Adicionar índices, paginar resultados |
| Dados inconsistentes se tenant fecha | Filtrar `Tenant.where.not(status: 'closed')` |
| Alertas duplicados | Verificar `alerts.where(type: type, read: false).last` antes de criar |
| Super admin vê dados sensíveis | Filtrar `CashExit` (despesas pessoais) de super admin |
