# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_01_01_000005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "user_id"
    t.bigint "service_id", null: false
    t.datetime "scheduled_at", null: false
    t.string "status", default: "pending", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_bookings_on_service_id"
    t.index ["tenant_id", "scheduled_at"], name: "index_bookings_on_tenant_id_and_scheduled_at"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.bigint "price_cents", default: 0, null: false
    t.string "sku"
    t.integer "stock_quantity", default: 0, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_products_on_sku", unique: true, where: "(sku IS NOT NULL)"
    t.index ["tenant_id", "slug"], name: "index_products_on_tenant_id_and_slug", unique: true
    t.index ["tenant_id"], name: "index_products_on_tenant_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.integer "duration_minutes", default: 30, null: false
    t.bigint "price_cents", default: 0, null: false
    t.string "category"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "slug"], name: "index_services_on_tenant_id_and_slug", unique: true
    t.index ["tenant_id"], name: "index_services_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "subdomain", null: false
    t.string "name", null: false
    t.string "custom_domain"
    t.string "status", default: "trial", null: false
    t.text "settings", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_domain"], name: "index_tenants_on_custom_domain", unique: true, where: "(custom_domain IS NOT NULL)"
    t.index ["subdomain"], name: "index_tenants_on_subdomain", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "role", default: "owner", null: false
    t.string "api_key", limit: 36
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["tenant_id", "email"], name: "index_users_on_tenant_id_and_email", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  add_foreign_key "bookings", "services"
  add_foreign_key "bookings", "tenants"
  add_foreign_key "products", "tenants"
  add_foreign_key "services", "tenants"
  add_foreign_key "users", "tenants"
end
