# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_11_093353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "customers", force: :cascade do |t|
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "address", null: false
    t.text "zip_code", null: false
    t.text "city", null: false
    t.text "country_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoice_lines", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "product_id"
    t.integer "quantity", null: false
    t.text "unit", null: false
    t.text "label", null: false
    t.text "vat_rate", null: false
    t.decimal "price", precision: 15, scale: 2, null: false
    t.decimal "tax", precision: 15, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invoice_id"], name: "index_invoice_lines_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_lines_on_product_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "customer_id"
    t.boolean "finalized", default: false, null: false
    t.boolean "paid", default: false, null: false
    t.date "date"
    t.date "deadline"
    t.decimal "total", precision: 15, scale: 2
    t.decimal "tax", precision: 15, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "session_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["session_id"], name: "index_invoices_on_session_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "label", null: false
    t.text "unit", null: false
    t.text "vat_rate", null: false
    t.decimal "unit_price", precision: 15, scale: 2, null: false
    t.decimal "unit_tax", precision: 15, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "name", null: false
    t.uuid "token", default: -> { "uuid_generate_v4()" }, null: false
    t.index ["name"], name: "index_sessions_on_name", unique: true
    t.index ["token"], name: "index_sessions_on_token", unique: true
  end

  add_foreign_key "invoice_lines", "invoices"
  add_foreign_key "invoice_lines", "products"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "sessions"
end
