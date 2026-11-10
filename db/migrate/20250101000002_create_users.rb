class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.references :tenant, null: false, foreign_key: true, type: :bigint
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :role, default: 'owner', null: false
      t.string :api_key, limit: 36
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :users, :tenant_id
    add_index :users, [ :tenant_id, :email ], unique: true
    add_index :users, :api_key, unique: true
  end
end
