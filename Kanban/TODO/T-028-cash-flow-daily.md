---
id: T-028
phase: Fase 2
priority: P0
status: todo
depends: T-024, T-026
tags: [feature, carva_billing, blocking]
---

# T-028 — Fluxo de caixa diário

## Objetivo

Registrar entradas (pagamentos) e saídas (despesas, retiradas pessoais) do dia, separando caixa do negócio do pessoal. O dono vê resumo do dia com faturamento, despesas, troco e lucro bruto. Atende S1 (fluxo de caixa, separar caixa), S3 (registrar pagamento).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Modelo | `CashEntry` (entrada) e `CashExit` (saída) separados |
| D2 | Tipos de entrada | `booking_payment`, `pix`, `cash`, `card` |
| D3 | Tipos de saída | `business_expense`, `personal_withdrawal`, `change_given` |
| D4 | Fechamento | `CashClose` model registra o fechamento do dia com saldo |
| D5 | Troco | Registrado como `CashExit` tipo `change_given` |

## Passo a Passo

### Passo 1 — Migrations

```ruby
# db/migrate/20250101000016_create_cash_entries.rb
class CreateCashEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :cash_entries do |t|
      t.references :tenant, null: false, type: :bigint
      t.references :booking, type: :bigint
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :type, null: false # booking_payment, pix, cash, card
      t.string :payment_method, null: false # pix, cash, card
      t.text :notes
      t.datetime :occurred_at

      t.timestamps
    end

    add_index :cash_entries, [:tenant_id, :occurred_at]

    create_table :cash_exits do |t|
      t.references :tenant, null: false, type: :bigint
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :type, null: false # business_expense, personal_withdrawal, change_given
      t.string :category # água, luz, shampoo, etc.
      t.text :notes
      t.datetime :occurred_at

      t.timestamps
    end

    add_index :cash_exits, [:tenant_id, :occurred_at]

    create_table :cash_closes do |t|
      t.references :tenant, null: false, type: :bigint
      t.decimal :opening_balance, default: 0.00
      t.decimal :closing_balance, null: false
      t.decimal :total_entries, default: 0.00
      t.decimal :total_exits, default: 0.00
      t.datetime :closed_at

      t.timestamps
    end

    add_index :cash_closes, [:tenant_id, :closed_at]
  end
end
```

### Passo 2 — Models

```ruby
# app/models/cash_entry.rb
class CashEntry < ApplicationRecord
  belongs_to :tenant
  belongs_to :booking, optional: true

  enum :type, { booking_payment: 'booking_payment', pix: 'pix', cash: 'cash', card: 'card' }, prefix: true
  enum :payment_method, { pix: 'pix', cash: 'cash', card: 'card' }, prefix: true

  validates :amount, numericality: { greater_than: 0 }

  def self.daily(tenant, date)
    where(tenant: tenant, occurred_at: date.beginning_of_day..date.end_of_day)
  end

  def self.total_daily(tenant, date)
    daily(tenant, date).sum(:amount)
  end
end

# app/models/cash_exit.rb
class CashExit < ApplicationRecord
  belongs_to :tenant

  enum :type, {
    business_expense: 'business_expense',
    personal_withdrawal: 'personal_withdrawal',
    change_given: 'change_given'
  }, prefix: true

  validates :amount, numericality: { greater_than: 0 }

  def self.daily(tenant, date)
    where(tenant: tenant, occurred_at: date.beginning_of_day..date.end_of_day)
  end

  def self.business_expenses(tenant, date)
    daily(tenant, date).where(type: 'business_expense')
  end

  def self.personal_withdrawals(tenant, date)
    daily(tenant, date).where(type: 'personal_withdrawal')
  end

  def self.change_given(tenant, date)
    daily(tenant, date).where(type: 'change_given')
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
        entries = CashEntry.daily(Current.tenant, date)
        exits = CashExit.daily(Current.tenant, date)

        render json: {
          date: date,
          total_entries: entries.sum(:amount),
          total_exits: exits.sum(:amount),
          gross_profit: entries.sum(:amount) - exits.sum(:amount),
          entries_by_type: entries.group(:type).sum(:amount),
          exits_by_type: exits.group(:type).sum(:amount)
        }
      end

      def register_payment
        entry = CashEntry.create!(
          tenant: Current.tenant,
          booking_id: params[:booking_id],
          amount: params[:amount],
          type: 'booking_payment',
          payment_method: params[:payment_method],
          occurred_at: Time.now
        )
        render json: { success: true, entry: entry }, status: :created
      end

      def register_change
        CashExit.create!(
          tenant: Current.tenant,
          amount: params[:amount],
          type: 'change_given',
          notes: params[:notes],
          occurred_at: Time.now
        )
        render json: { success: true }
      end

      def close_day
        date = params[:date]&.to_date || Date.today
        entries = CashEntry.daily(Current.tenant, date)
        exits = CashExit.daily(Current.tenant, date)

        close = CashClose.create!(
          tenant: Current.tenant,
          opening_balance: params[:opening_balance] || 0,
          closing_balance: (params[:opening_balance] || 0) + entries.sum(:amount) - exits.sum(:amount),
          total_entries: entries.sum(:amount),
          total_exits: exits.sum(:amount),
          closed_at: Time.now
        )
        render json: { success: true, close: close }
      end
    end
  end
end
```

## Checklist

- [ ] Migrations `create_cash_entries`, `create_cash_exits`, `create_cash_closes` rodam com sucesso
- [ ] `CashEntry` model com tipos e método `daily`
- [ ] `CashExit` model com tipos e métodos `business_expenses`, `personal_withdrawals`, `change_given`
- [ ] `CashClose` model registra fechamento do dia
- [ ] `CashFlowController#daily_summary` retorna resumo do dia
- [ ] `CashFlowController#register_payment` registra pagamento
- [ ] `CashFlowController#register_change` registra troco
- [ ] `CashFlowController#close_day` fecha o caixa
- [ ] Testes RSpec: cash models, controller, daily summary

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Pagamento duplicado | Verificar `booking_id` antes de registrar |
| Troco maior que valor | Validar `change <= amount - change` no controller |
| Fechamento duplicado | Verificar `cash_closes.where(closed_at: date).exists?` |
| Saldo negativo | Verificar `opening_balance + entries - exits >= 0` |
