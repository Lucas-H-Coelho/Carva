# frozen_string_literal: true

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

    add_index :bookings, [ :tenant_id, :scheduled_at ]
  end
end
