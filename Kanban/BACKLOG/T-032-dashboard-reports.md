---
id: T-032
phase: Fase 2
priority: P0
status: todo
depends: T-024, T-026, T-028
tags: [feature, carva_dashboard, blocking]
---

# T-032 — Dashboard do dono (relatórios e gráficos)

## Objetivo

Tela de dashboard para o dono ver resumo do dia: carros lavados, faturamento, comissão, estoque baixo, clientes mais frequentes. Gráficos de faturamento semanal/mensal. Exportação em PDF/Excel. Atende S1 (resumo do dia, relatório mensal, clientes frequentes).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | API-first | Dashboard consome REST API, não tem template engine |
| D2 | Gráficos | Dados brutos via API, frontend renderiza (React Chart.js) |
| D3 | Exportação | PDF (PDFKit) e Excel (Axlsx) gerados no servidor |
| D4 | Permissões | Dono vê só sua unidade, gerente vê todas |

## Passo a Passo

### Passo 1 — Service: DashboardService

```ruby
# app/services/dashboard_service.rb
class DashboardService
  def self.daily(tenant, date = Date.today)
    {
      date: date,
      bookings_count: tenant.bookings.where(scheduled_at: date.beginning_of_day..date.end_of_day).count,
      completed_count: tenant.bookings.where(status: 'completed', scheduled_at: date.beginning_of_day..date.end_of_day).count,
      revenue: CashEntry.daily(tenant, date).sum(:amount),
      expenses: CashExit.daily(tenant, date).sum(:amount),
      gross_profit: CashEntry.daily(tenant, date).sum(:amount) - CashExit.daily(tenant, date).sum(:amount),
      low_stock_products: tenant.products.where('quantity <= min_quantity').pluck(:name, :quantity),
      top_customers: tenant.bookings.joins(:customer)
        .where(scheduled_at: date.beginning_of_month..date.end_of_day)
        .group(:customer_id)
        .count
        .sort_by { |_k, v| -v }
        .first(5),
      no_show_count: tenant.bookings.where(status: 'cancelled', scheduled_at: date.beginning_of_day..date.end_of_day).count
    }
  end

  def self.weekly(tenant, weeks = 4)
    (1..weeks).map do |i|
      week_start = Date.today - i.weeks
      day = daily(tenant, week_start)
      day.merge(week_start: week_start)
    end
  end

  def self.monthly(tenant, months = 6)
    (1..months).map do |i|
      month = Date.today << i
      {
        month: month.strftime('%m/%Y'),
        revenue: CashEntry.where(tenant: tenant, occurred_at: month.beginning_of_month..month.end_of_month).sum(:amount),
        bookings: tenant.bookings.where(scheduled_at: month.beginning_of_month..month.end_of_month).count,
        expenses: CashExit.where(tenant: tenant, occurred_at: month.beginning_of_month..month.end_of_month).sum(:amount)
      }
    end
  end
end
```

### Passo 2 — Controller: Dashboard

```ruby
# app/controllers/api/v1/dashboard_controller.rb
module Api
  module V1
    class DashboardController < ApplicationController
      before_action :require_owner

      def daily
        render json: DashboardService.daily(Current.tenant, params[:date])
      end

      def weekly
        render json: DashboardService.weekly(Current.tenant, params[:weeks] || 4)
      end

      def monthly
        render json: DashboardService.monthly(Current.tenant, params[:months] || 6)
      end

      def export_pdf
        date = params[:date]&.to_date || Date.today
        data = DashboardService.daily(Current.tenant, date)
        pdf = PDFKit.new(render_to_string(template: 'reports/daily', locals: { data: data }))
        send_data pdf.to_pdf, filename: "relatorio_#{date}.pdf"
      end

      def export_excel
        data = DashboardService.monthly(Current.tenant, 6)
        workbook = Axlsx::Package.new
        workbook.workbook.add_worksheet(name: 'Relatório') do |sheet|
          sheet.add_row ['Mês', 'Faturamento', 'Agendamentos', 'Despesas']
          data.each do |row|
            sheet.add_row [row[:month], row[:revenue], row[:bookings], row[:expenses]]
          end
        end
        send_data workbook.to_stream, filename: 'relatorio.xlsx'
      end
    end
  end
end
```

## Checklist

- [ ] `DashboardService.daily` retorna resumo do dia
- [ ] `DashboardService.weekly` retorna dados semanais
- [ ] `DashboardService.monthly` retorna dados mensais
- [ ] `DashboardController#daily` retorna JSON do dia
- [ ] `DashboardController#weekly` retorna JSON semanal
- [ ] `DashboardController#monthly` retorna JSON mensal
- [ ] `DashboardController#export_pdf` gera PDF
- [ ] `DashboardController#export_excel` gera Excel
- [ ] Testes RSpec: dashboard service, controller, export

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Query lenta com muitos dados | Paginar, adicionar índices |
| PDF/Excel muito grande | Limitar período máximo (6 meses) |
| Dados inconsistentes | Usar transações DB para consistência |
| Exportação bloqueia request | Worker assíncrono para exportações grandes |
