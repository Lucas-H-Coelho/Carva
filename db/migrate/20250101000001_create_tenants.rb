class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :subdomain, null: false
      t.string :name, null: false
      t.string :custom_domain
      t.string :status, default: 'trial', null: false
      t.text :settings, default: '{}', null: false
      t.timestamps
    end
    add_index :tenants, :subdomain, unique: true
    add_index :tenants, :custom_domain, unique: true, where: 'custom_domain IS NOT NULL'
  end
end
