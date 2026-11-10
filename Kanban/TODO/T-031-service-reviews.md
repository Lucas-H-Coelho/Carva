---
id: T-031
phase: Fase 3
priority: P1
status: todo
depends: T-024
tags: [feature, carva_storefront]
---

# T-031 — Avaliações de serviço (reviews)

## Objetivo

Permitir que clientes avaliem o serviço com 1-5 estrelas e registrem reclamações. O dono vê nota média por serviço e unidades com avaliação baixa. Atende S2 (avaliar, reclamar), S1 (ver nota média), S4 (avaliação por unidade).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Modelo | `Review` com `customer_id`, `booking_id`, `rating` (1-5), `comment` |
| D2 | Prazo | 48h após conclusão para avaliar/reclamar |
| D3 | Reclamação | `Review` com `rating <= 3` + `complaint: true` |
| D4 | Resposta | `Review#response` (texto do dono) + `resolved_at` |
| D5 | Escalada | `Review#escalated: true` → reembolso integral em 48h |

## Passo a Passo

### Passo 1 — Migration Reviews

```ruby
# db/migrate/20250101000019_create_reviews.rb
class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :customer, null: false, foreign_key: { to_table: :customers }, type: :bigint
      t.references :booking, null: false, foreign_key: true, type: :bigint
      t.integer :rating, null: false
      t.text :comment, limit: 200
      t.boolean :complaint, default: false
      t.text :response
      t.boolean :escalated, default: false
      t.datetime :resolved_at
      t.datetime :expires_at

      t.timestamps
    end

    add_index :reviews, :booking_id, unique: true
    add_index :reviews, [:customer_id, :created_at]
  end
end
```

### Passo 2 — Modelo Review

```ruby
# app/models/review.rb
class Review < ApplicationRecord
  belongs_to :customer
  belongs_to :booking

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 200 }
  validates :booking_id, uniqueness: true

  before_create :set_expiry

  def expired?
    expires_at < Time.now
  end

  def is_complaint?
    rating <= 3
  end

  def resolve!
    self.response = 'Resolvido'
    self.resolved_at = Time.now
    save!
  end
end
```

### Passo 3 — Service: ReviewService

```ruby
# app/services/review_service.rb
class ReviewService
  def self.create_review(customer, booking, rating, comment = nil)
    return false if booking.completed_at < 48.hours.ago
    return false if Review.where(booking: booking).exists?

    review = Review.create!(
      customer: customer,
      booking: booking,
      rating: rating,
      comment: comment,
      complaint: rating <= 3
    )

    # 5 estrelas = desconto na próxima
    if rating == 5
      customer.loyalty_account&.increment!(:credits, 5.00) if customer.loyalty_account
    end

    review
  end

  def self.respond_to_review(review, response_text)
    review.response = response_text
    review.resolved_at = Time.now
    review.save!
  end

  def self.escalate_review(review)
    review.escalated = true
    review.save!
    # TODO: Processar reembolso integral
  end

  def self.average_rating(tenant, date_range = Date.today.beginning_of_month..Date.today)
    Review.joins(:booking)
      .where('bookings.tenant_id = ? AND bookings.completed_at >= ?', tenant.id, date_range.beginning)
      .average(:rating) || 0
  end
end
```

## Checklist

- [ ] Migration `create_reviews` roda com sucesso
- [ ] `Review` model com rating, complaint, response
- [ ] `Review#expired?` verifica prazo de 48h
- [ ] `ReviewService.create_review` cria review + bônus 5 estrelas
- [ ] `ReviewService.respond_to_review` registra resposta do dono
- [ ] `ReviewService.escalate_review` escala para reembolso
- [ ] `ReviewService.average_rating` calcula média por tenant
- [ ] Testes RSpec: review model, service, average rating

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Review duplicada | `booking_id` unique index |
| Review após 48h | Verificar `completed_at` no create |
| Escalada sem reembolso | Registrar `Review#escalated` + trigger de reembolso |
| Rating inválido | Enum 1-5 + validation |
