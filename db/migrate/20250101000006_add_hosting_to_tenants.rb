class AddHostingToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :hosting_type, :string, default: 'self_hosted', null: false
    add_column :tenants, :plan, :string, default: 'lava', null: false
    add_column :tenants, :features, :text, default: '{}', null: false

    add_column :tenants, :license_key, :string
    add_column :tenants, :license_expires_at, :datetime

    add_column :tenants, :stripe_customer_id, :string
    add_column :tenants, :subscription_id, :string

    add_column :tenants, :revenue_share_rate, :decimal, precision: 5, scale: 2, default: 0.15, null: false
    add_column :tenants, :revenue_share_cap, :decimal, precision: 10, scale: 2, default: 0.0, null: false

    add_index :tenants, :hosting_type
    add_index :tenants, :plan
    add_index :tenants, :stripe_customer_id, where: 'stripe_customer_id IS NOT NULL'
    add_index :tenants, :subscription_id, where: 'subscription_id IS NOT NULL'
  end
end
