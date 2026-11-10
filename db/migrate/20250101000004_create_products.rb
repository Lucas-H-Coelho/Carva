# frozen_string_literal: true

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
    add_index :products, :sku, unique: true, where: 'sku IS NOT NULL'
  end
end
