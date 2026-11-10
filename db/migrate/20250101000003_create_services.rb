# frozen_string_literal: true

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
  end
end
