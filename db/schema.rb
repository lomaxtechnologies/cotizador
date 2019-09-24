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

ActiveRecord::Schema.define(version: 2019_09_23_224019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.text "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quotation_id", null: false
    t.index ["quotation_id"], name: "index_attachments_on_quotation_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.string "modifier_user"
    t.string "creator_user"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "nit"
    t.string "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "modifier_user"
    t.string "creator_user"
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "measure_units", force: :cascade do |t|
    t.string "name"
    t.string "unit_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prices", force: :cascade do |t|
    t.decimal "prices"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_prices_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "material_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "brand_id", null: false
    t.bigint "measure_unit_id", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["material_id"], name: "index_products_on_material_id"
    t.index ["measure_unit_id"], name: "index_products_on_measure_unit_id"
  end

  create_table "quotation_products", force: :cascade do |t|
    t.decimal "amount"
    t.decimal "holgura"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quotation_id", null: false
    t.bigint "product_id", null: false
    t.index ["product_id"], name: "index_quotation_products_on_product_id"
    t.index ["quotation_id"], name: "index_quotation_products_on_quotation_id"
  end

  create_table "quotation_services", force: :cascade do |t|
    t.decimal "amount"
    t.decimal "holgura"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "service_id", null: false
    t.bigint "quotation_id", null: false
    t.index ["quotation_id"], name: "index_quotation_services_on_quotation_id"
    t.index ["service_id"], name: "index_quotation_services_on_service_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.integer "code"
    t.date "quotation_date"
    t.string "currency"
    t.text "credits"
    t.text "payment_condition"
    t.text "warranty"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id", null: false
    t.bigint "user_id", null: false
    t.index ["client_id"], name: "index_quotations_on_client_id"
    t.index ["user_id"], name: "index_quotations_on_user_id"
  end

  create_table "quotations_notes", force: :cascade do |t|
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quotation_id", null: false
    t.index ["quotation_id"], name: "index_quotations_notes_on_quotation_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "creation_price"
    t.decimal "actual_price"
    t.string "creator_user"
    t.string "modifier_user"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_details", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.string "phone"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.bigint "role_id", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "attachments", "quotations"
  add_foreign_key "prices", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "materials"
  add_foreign_key "products", "measure_units"
  add_foreign_key "quotation_products", "products"
  add_foreign_key "quotation_products", "quotations"
  add_foreign_key "quotation_services", "quotations"
  add_foreign_key "quotation_services", "services"
  add_foreign_key "quotations", "clients"
  add_foreign_key "quotations", "users"
  add_foreign_key "quotations_notes", "quotations"
  add_foreign_key "user_details", "users"
  add_foreign_key "users", "roles"
end
