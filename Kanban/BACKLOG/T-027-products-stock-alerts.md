---
id: T-027
phase: Fase 2
priority: P0
status: todo
depends: T-013
tags: [feature, carva_inventory, blocking]
---

# T-027 — Products CRUD, estoque e alertas de baixo estoque

## Objetivo

Permitir que o dono funcione como estoque de insumos (shampoo, cera, toalha, etc.) com controle de quantidade, nível mínimo de alerta, e consumo automático quando um serviço é concluído. Atende S1 (ver estoque), S3 (reportar estoque baixo), S4 (estoque consolidado).

## Decisões

| # | Decisão | Escolha |
|---|---------|---------|
| D1 | Modelo | `Product` com `tenant_id`, `name`, `unit` (L, kg, un), `quantity`, `min_quantity` |
| D2 | Consumo | Desconto automático de `service.consumption` ao concluir booking |
| D3 | Alerta | Webhook/WhatsApp quando `quantity <= min_quantity` |
| D4 | Reposição | `StockAdjustment` model para registrar compras/reposições |
| D5 | Transferência | `StockTransfer` model para mover entre tenants (S4) |

## Passo a Passo

### Passo 1 — Migration Products + StockAdjustments

```ruby
# db/migrate/20250101000014_create_products.rb
class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :tenant, null: false, type: :bigint
      t.string :name, null: false
      t.string :unit, default: 'L', null: false # L, kg, un
      t.decimal :quantity, precision: 8, scale: 2, default: 0.00
      t.decimal :min_quantity, precision: 8, scale: 2, default: 1.00
      t.string :status, default: 'active', null: false

      t.timestamps
    end

    add_index :products, [:tenant_id, :status]

    create_table :stock_adjustments do |t|
      t.references :tenant, null: false, type: :bigint
      t.references :product, null: false, foreign_key: true, type: :bigint
      t.decimal :quantity, precision: 8, scale: 2, null: false
      t.string :type, null: false # purchase, consumption, transfer_in, transfer_out
      t.text :notes

      t.timestamps
    end

    add_index :stock_adjustments, [:tenant_id, :created_at]
  end
end
```

### Passo 2 — Modelo Product

```ruby
# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :tenant

  enum :status, { active: 'active', inactive: 'inactive' }, prefix: true

  validates :name, :quantity, :unit, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def low_stock?
    quantity <= min_quantity
  end

  def consume!(amount)
    return false unless amount <= quantity

    self.quantity -= amount
    save!

    StockAdjustment.create!(
      tenant: tenant,
      product: self,
      quantity: -amount.abs,
      type: 'consumption',
      notes: 'Consumo automático por serviço'
    )

    true
  end
end
```

### Passo 3 — Service: StockService

```ruby
# app/services/stock_service.rb
class StockService
  def self.adjust(tenant, product_id, quantity, type, notes = nil)
    product = tenant.products.find(product_id)
    product.quantity += quantity
    product.save!

    StockAdjustment.create!(
      tenant: tenant,
      product: product,
      quantity: quantity,
      type: type,
      notes: notes
    )

    # Alerta se estoque baixo
    if product.low_stock?
      send_low_stock_alert(tenant, product)
    end
  end

  def self.consumed_by_service(tenant, service)
    service.consumption_hash.each do |product_name, amount|
      product = tenant.products.find_by(name: product_name)
      product&.consume!(amount)
    end
  end

  private
  def self.send_low_stock_alert(tenant, product)
    # Enviar WhatsApp para dono
    send_whatsapp_notification(
      tenant.owner,
      "⚠️ Estoque baixo: #{product.name} (#{product.quantity} #{product.unit} restantes)"
    )
  end
end
```

## Checklist

- [ ] Migration `create_products` + `create_stock_adjustments` roda com sucesso
- [ ] `Product` model com quantity, min_quantity, low_stock?
- [ ] `Product.consume!` desconta + registra ajuste
- [ ] `StockAdjustment` model com type (purchase, consumption, transfer)
- [ ] `StockService.adjust` ajusta estoque + registra
- [ ] `StockService.consumed_by_service` consome insumos ao concluir serviço
- [ ] `StockService.send_low_stock_alert` envia alerta WhatsApp
- [ ] Testes RSpec: product model, stock service, low stock alert

## Riscos

| Risco | Mitigação |
|-------|-----------|
| Consumo negativo | Verificar `quantity >= amount` antes de consumir |
| Produto não encontrado no consumo | Verificar `product.present?` antes de consumir |
| Alerta spam (mesmo produto) | Debounce: máximo 1 alerta por hora por produto |
| Transferência entre tenants | Validar `StockTransfer` com autorização S4 |
