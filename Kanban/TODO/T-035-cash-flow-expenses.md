---
id: T-035
phase: Fase 2
priority: P1
status: todo
depends: T-028
tags: [feature, carva_billing]
---

# T-035 — Despesas, lucro líquido e controle de troco

## Objetivo

Expandir o fluxo de caixa com despesas do negócio, retiradas pessoais, controle de troco e contas a pagar. O dono vê lucro líquido do dia (faturamento - despesas - retiradas). Atende S1 (despesas, lucro líquido, troco, contas a pagar).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Despesas | `CashExit` com `category` (água, luz, shampoo, equipamento) |
| D2 | Retiradas | `CashExit` tipo `personal_withdrawal` — separado das despesas |
| D3 | Troco | `CashExit` tipo `change_given` — registrado automaticamente no pagamento |
| D4 | Contas a pagar | `Bill` model com `due_date`, `amount`, `recurring` |
| D5 | Alerta | Notificação 5 dias antes do vencimento |

## Passo a Passo

### Passo 1 — Migration Bills (contas a pagar)

```ruby
# db/migrate/20250101000022_create_bills.rb
class CreateBills < ActiveRecord::Migration[8.0]
  def change
    create_table :bills do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.string :name, null: false # Água, Luz, Shampoo, etc.
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.date :due_date, null: false
      t.string :recurrence, default: 'none' # none, weekly, monthly
      t.string :category, null: false # utility, supply, equipment, rent
      t.boolean :paid, default: false
      t.datetime :paid_at
      t.string :payment_method # pix, cash, card

      t.timestamps
    end

    add_index :bills, [:tenant_id, :paid, :due_date]
  end
end
```

### Passo 2 — Service: CashFlow

```ruby
# app/services/cash_flow_service.rb
class CashFlowService
  def self.daily_summary(tenant, date = Date.today)
    entries = CashEntry.where(tenant: tenant, occurred_at: date.beginning_of_day..date.end_of_day)
    exits = CashExit.where(tenant: tenant, occurred_at: date.beginning_of_day..date.end_of_day)
    expenses = CashExit.business_expenses(tenant, date)
    withdrawals = CashExit.personal_withdrawals(tenant, date)
    change_given = CashExit.change_given(tenant, date).sum(:amount)

    revenue = entries.sum(:amount)
    expenses_total = expenses.sum(:amount)
    withdrawals_total = withdrawals.sum(:amount)
    change_total = change_given

    {
      date: date,
      revenue: revenue,
      expenses: expenses_total,
      withdrawals: withdrawals_total,
      change_given: change_total,
      gross_profit: revenue - expenses_total,
      net_profit: revenue - expenses_total - withdrawals_total,
      cash_in_register: revenue - change_total,
      breakdown: {
        pix: entries.where(payment_method: 'pix').sum(:amount),
        cash: entries.where(payment_method: 'cash').sum(:amount),
        card: entries.where(payment_method: 'card').sum(:amount)
      }
    }
  end

  def self.upcoming_bills(tenant, days = 7)
    Bill.where(
      tenant: tenant,
      paid: false,
      due_date: Date.today..Date.today + days.days
    ).order(:due_date)
  end

  def self.pay_bill(bill)
    bill.paid = true
    bill.paid_at = Time.now
    bill.save!

    # Registrar saída no fluxo de caixa
    CashExit.create!(
      tenant: bill.tenant,
      amount: bill.amount,
      type: 'business_expense',
      category: bill.category,
      notes: "Conta paga: #{bill.name}",
      occurred_at: Time.now
    )
  end
end
```

### Passo 3 — Controller: CashFlow

```ruby
# app/controllers/api/v1/cash_flow_controller.rb
module Api
  module V1
    class CashFlowController < ApplicationController
      def daily_summary
        date = params[:date]&.to_date || Date.today
        render json: CashFlowService.daily_summary(Current.tenant, date)
      end

      def new_expense
        CashExit.create!(
          tenant: Current.tenant,
          amount: params[:amount],
          type: 'business_expense',
          category: params[:category],
          notes: params[:notes],
          occurred_at: Time.now
        )
        render json: { success: true }
      end

      def new_withdrawal
        CashExit.create!(
          tenant: Current.tenant,
          amount: params[:amount],
          type: 'personal_withdrawal',
          notes: params[:notes],
          occurred_at: Time.now
        )
        render json: { success: true }
      end

      def upcoming_bills
        render json: CashFlowService.upcoming_bills(Current.tenant)
      end

      def pay_bill(bill_id)
        bill = Current.tenant.bills.find(bill_id)
        CashFlowService.pay_bill(bill)
        render json: { success: true }
      end
    end
  end
end
```

## Checklist

- [ ] Migration `create_bills` roda com sucesso
- [ ] `CashFlowService.daily_summary` retorna resumo completo do dia
- [ ] `CashFlowService.upcoming_bills` retorna contas próximas
- [ ] `CashFlowService.pay_bill` marca conta como paga + registra saída
- [ ] `CashFlowController#daily_summary` retorna JSON do resumo
- [ ] `CashFlowController#new_expense` registra despesa
- [ ] `CashFlowController#new_withdrawal` registra retirada pessoal
- [ ] `CashFlowController#upcoming_bills` retorna contas a pagar
- [ ] `CashFlowController#pay_bill` paga conta + registra saída
- [ ] Testes RSpec: cash flow service, controller, bill model

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Despesa duplicada | Verificar `bills.where(name: name, due_date: date, paid: false)` |
| Troco calculado errado | Calcular no controller de pagamento, não no cash flow |
| Retirada pessoal misturada com despesa | Tipos separados no `CashExit` |
| Conta paga duas vezes | `paid` boolean + `paid_at` timestamp |
