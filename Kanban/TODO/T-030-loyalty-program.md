---
id: T-030
phase: Fase 3
priority: P1
status: todo
depends: T-024, T-026
tags: [feature, carva_marketing]
---

# T-030 — Programa de fidelidade (carimbo digital)

## Objetivo

Implementar programa de fidelidade onde clientes ganham pontos por cada lavagem e trocam por lavagens grátis ou descontos. Atende S2 (pontos, créditos, indicação de amigo), S1 (clientes mais frequentes).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Pontos | Simples: 10pts (simples), 20pts (completa), 30pts (premium) |
| D2 | Resgate | 50pts = lavagem grátis, 20pts = 10% desconto |
| D3 | Bônus frequência | 4 lavagens/mês → 10% desconto na 5ª |
| D4 | Indicação | Indicado ganha 20% primeira lavagem, indicador ganha R$10 crédito |
| D5 | Expiração | Pontos não expiram (permanecem até resgate) |

## Passo a Passo

### Passo 1 — Migration Loyalty

```ruby
# db/migrate/20250101000018_create_loyalty.rb
class CreateLoyalty < ActiveRecord::Migration[8.0]
  def change
    create_table :loyalty_accounts do |t|
      t.references :customer, null: false, foreign_key: { to_table: :customers }, type: :bigint
      t.decimal :points, default: 0.00
      t.decimal :credits, default: 0.00, precision: 8, scale: 2
      t.integer :visits_this_month, default: 0
      t.integer :total_visits, default: 0

      t.timestamps
    end

    add_index :loyalty_accounts, :customer_id, unique: true

    create_table :loyalty_transactions do |t|
      t.references :loyalty_account, null: false, foreign_key: true, type: :bigint
      t.decimal :points_earned, default: 0.00
      t.decimal :points_spent, default: 0.00
      t.decimal :credits_earned, default: 0.00
      t.string :type # points_earned, points_spent, credits_earned, referral
      t.references :booking, type: :bigint
      t.text :notes

      t.timestamps
    end

    add_index :loyalty_transactions, :loyalty_account_id
  end
end
```

### Passo 2 — Models

```ruby
# app/models/loyalty_account.rb
class LoyaltyAccount < ApplicationRecord
  belongs_to :customer
  has_many :transactions, class_name: 'LoyaltyTransaction', dependent: :destroy

  def points_for_service(service)
    case service.name
    when /Simples/i then 10
    when /Completa/i then 20
    when /Premium/i then 30
    else 10
    end
  end

  def can_redeem_free_wash?
    points >= 50
  end

  def can_redeem_discount?
    points >= 20
  end

  def monthly_discount_eligible?
    visits_this_month >= 4
  end
end

# app/models/loyalty_transaction.rb
class LoyaltyTransaction < ApplicationRecord
  belongs_to :loyalty_account
  belongs_to :booking, optional: true

  enum :type, { points_earned: 'points_earned', points_spent: 'points_spent', credits_earned: 'credits_earned', referral: 'referral' }, prefix: true
end
```

### Passo 3 — Service: LoyaltyService

```ruby
# app/services/loyalty_service.rb
class LoyaltyService
  def self.earn_points(customer, booking)
    account = customer.loyalty_account || LoyaltyAccount.create!(customer: customer)
    points = account.points_for_service(booking.service)

    account.points += points
    account.total_visits += 1
    account.visits_this_month += 1
    account.save!

    LoyaltyTransaction.create!(
      loyalty_account: account,
      points_earned: points,
      type: 'points_earned',
      booking: booking,
      notes: "Ganhou #{points} pontos por #{booking.service.name}"
    )

    # Bônus de frequência
    if account.visits_this_month == 4
      account.credits += 10.00
      LoyaltyTransaction.create!(
        loyalty_account: account,
        credits_earned: 10.00,
        type: 'credits_earned',
        notes: 'Bônus: 4 lavagens no mês = R$10 crédito'
      )
    end
  end

  def self.redeem_discount(customer)
    account = customer.loyalty_account
    return false unless account&.can_redeem_discount?

    account.points -= 20
    account.credits += 5.00
    account.save!

    LoyaltyTransaction.create!(
      loyalty_account: account,
      points_spent: 20,
      credits_earned: 5.00,
      type: 'points_spent',
      notes: 'Resgatou 20 pontos = 10% desconto + R$5 crédito'
    )
    true
  end
end
```

## Checklist

- [ ] Migration `create_loyalty` roda com sucesso
- [ ] `LoyaltyAccount` model com points, credits, visits
- [ ] `LoyaltyAccount.points_for_service` retorna pontos por tipo
- [ ] `LoyaltyTransaction` model com tipos
- [ ] `LoyaltyService.earn_points` adiciona pontos + bônus
- [ ] `LoyaltyService.redeem_discount` resgata desconto
- [ ] Testes RSpec: loyalty service, earn/redeem flow

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Pontos ganhos duas vezes | Verificar `loyalty_transactions.where(booking: booking).exists?` |
| Crédito expira | Adicionar `credits_expires_at` no futuro |
| Indicação fraudulenta | Verificar `customer.phone_number` único |
| Bônus frequência não resetado | Worker mensal reseta `visits_this_month` |
