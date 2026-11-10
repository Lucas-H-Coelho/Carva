---
id: T-010
phase: Fase 1
priority: P1
status: done
depends: T-008
tags: [feature, carva_inventory, blocking]
---

# T-010 — WashService + domain models (Service, Product, Booking)

## Objetivo

Implementar os modelos de domínio principal: `Service` (serviços de lava-carre), `Product` (produtos à venda), e `Booking` (agendamentos). São as entidades centrais do negócio.

---

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Service model | `services` com `tenant_id`, `name`, `slug`, `description` (text), `duration_minutes` (int), `price_cents` (bigint), `category` (string), `active` (boolean) |
| D2 | Product model | `products` com `tenant_id`, `name`, `slug`, `description` (text), `price_cents` (bigint), `sku` (string), `stock_quantity` (int, default 0), `active` (boolean) |
| D3 | Booking model | `bookings` com `tenant_id`, `user_id` (nullable), `service_id`, `scheduled_at` (datetime), `status` (enum: pending, confirmed, completed, cancelled), `notes` (text) |
| D4 | Preços | Armazenar em cents (bigint) — evita floating point |
| D5 | Slug | Gerado automaticamente do name + tenant scope |

---

## Passo a Passo

### Passo 1 — Migration Services

```ruby
# db/migrate/20250101000003_create_services.rb
class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :duration_minutes, default: 30, null: false
      t.bigint :price_cents, default: 0, null: false
      t.string :category
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :services, [ :tenant_id, :slug ], unique: true
    add_index :services, :tenant_id
  end
end
```

### Passo 2 — Migration Products

```ruby
# db/migrate/20250101000004_create_products.rb
class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.bigint :price_cents, default: 0, null: false
      t.string :sku
      t.integer :stock_quantity, default: 0, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :products, [ :tenant_id, :slug ], unique: true
    add_index :products, :tenant_id
    add_index :products, :sku, unique: true, where: 'sku IS NOT NULL'
  end
end
```

### Passo 3 — Migration Bookings

```ruby
# db/migrate/20250101000005_create_bookings.rb
class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.references :user, type: :bigint
      t.references :service, null: false, foreign_key: true, type: :bigint
      t.datetime :scheduled_at, null: false
      t.string :status, default: 'pending', null: false
      t.text :notes

      t.timestamps
    end

    add_index :bookings, :tenant_id
    add_index :bookings, [ :tenant_id, :scheduled_at ]
  end
end
```

### Passo 4 — Modelo Service

```ruby
# app/engines/carva_inventory/app/models/carva/inventory/service.rb
module Carva
  module Inventory
    class Service < ApplicationRecord
      self.table_name = 'services'

      belongs_to :tenant
      has_many :bookings, class_name: 'Carva::Inventory::Booking'

      validates :name, presence: true, length: { maximum: 255 }
      validates :slug, presence: true
      validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
      validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

      before_validation :generate_slug

      def active?
        active
      end

      def price
        Money.new(price_cents, 'BRL')
      end

      private
      def generate_slug
        self.slug = name.to_s.parameterize if slug.blank? && name.present?
      end
    end
  end
end
```

### Passo 5 — Modelo Product

```ruby
# app/engines/carva_inventory/app/models/carva/inventory/product.rb
module Carva
  module Inventory
    class Product < ApplicationRecord
      self.table_name = 'products'

      belongs_to :tenant
      has_many :line_items

      validates :name, presence: true, length: { maximum: 255 }
      validates :slug, presence: true
      validates :sku, uniqueness: true, allow_nil: true
      validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
      validates :stock_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

      before_validation :generate_slug

      def in_stock?
        stock_quantity > 0
      end

      private
      def generate_slug
        self.slug = name.to_s.parameterize if slug.blank? && name.present?
      end
    end
  end
end
```

### Passo 6 — Modelo Booking

```ruby
# app/engines/carva_storefront/app/models/carva/storefront/booking.rb
module Carva
  module Storefront
    class Booking < ApplicationRecord
      self.table_name = 'bookings'

      enum :status, { pending: 'pending', confirmed: 'confirmed', completed: 'completed', cancelled: 'cancelled' }, prefix: true

      belongs_to :tenant
  belongs_to :user, optional: true
      belongs_to :service, class_name: 'Carva::Inventory::Service'

      validates :scheduled_at, presence: true
      validates :status, presence: true

      scope :upcoming, -> { where('scheduled_at > ?', Time.current).where.not(status: %w[completed cancelled]) }
      scope :today, -> { where(scheduled_at: Time.current.beginning_of_day..Time.current.end_of_day) }
    end
  end
end
```

---

## Checklist de Aceitação

- [ ] 3 migrations criadas e rodam sem erro
- [ ] 3 modelos com validações e relacionamentos
- [ ] `generate_slug` funciona (before_validation)
- [ ] `price` retorna Money object
- [ ] `in_stock?` verifica stock_quantity > 0
- [ ] Scopes `upcoming` e `today` funcionam
- [ ] Testes RSpec: model validations, scopes, callbacks
- [ ] `bin/rails db:migrate` limpo

---

## Riscos

| Risco | Mitigação |
|-------|-----------|
| `Money` não existe ainda | Criar `app/value_objects/carva_payments/money.rb` simples (int + currency) |
| `line_items` referenciado mas não criado | Adicionar placeholder ou remover por enquanto |
| `duration_minutes` sem unidade | Documentar como minutos no API response |
| Booking sem user_id | `optional: true` — booking pode ser anônimo (walk-in) |
