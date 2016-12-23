# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150116215040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "accession_panels", force: :cascade do |t|
    t.integer  "accession_id"
    t.integer  "panel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accession_panels", ["accession_id", "panel_id"], name: "index_accession_panels_on_accession_id_and_panel_id", using: :btree

  create_table "accessions", force: :cascade do |t|
    t.integer  "patient_id"
    t.datetime "drawn_at"
    t.integer  "drawer_id"
    t.datetime "received_at"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reported_at"
    t.integer  "reporter_id"
    t.integer  "doctor_id"
    t.string   "icd9",        limit: 510
  end

  add_index "accessions", ["doctor_id"], name: "index_accessions_on_doctor_id", using: :btree
  add_index "accessions", ["drawer_id"], name: "index_accessions_on_drawer_id", using: :btree
  add_index "accessions", ["patient_id"], name: "index_accessions_on_patient_id", using: :btree
  add_index "accessions", ["receiver_id"], name: "index_accessions_on_receiver_id", using: :btree
  add_index "accessions", ["reporter_id"], name: "index_accessions_on_reporter_id", using: :btree

  create_table "claims", force: :cascade do |t|
    t.integer  "accession_id"
    t.string   "number",                limit: 510
    t.string   "external_number",       limit: 510
    t.datetime "claimed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "insurance_provider_id"
  end

  add_index "claims", ["accession_id"], name: "index_claims_on_accession_id", unique: true, using: :btree
  add_index "claims", ["insurance_provider_id"], name: "index_claims_on_insurance_provider_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["name"], name: "index_departments_on_name", unique: true, using: :btree

  create_table "doctors", force: :cascade do |t|
    t.string   "name",       limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender",     limit: 510
  end

  add_index "doctors", ["name"], name: "index_doctors_on_name", using: :btree

  create_table "insurance_providers", force: :cascade do |t|
    t.string   "name",          limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_list_id"
  end

  add_index "insurance_providers", ["price_list_id"], name: "index_insurance_providers_on_price_list_id", using: :btree

  create_table "lab_test_panels", force: :cascade do |t|
    t.integer  "lab_test_id"
    t.integer  "panel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lab_test_panels", ["lab_test_id", "panel_id"], name: "index_lab_test_panels_on_lab_test_id_and_panel_id", using: :btree

  create_table "lab_test_value_option_joints", force: :cascade do |t|
    t.integer  "lab_test_value_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lab_test_id"
  end

  create_table "lab_test_values", force: :cascade do |t|
    t.string   "value",      limit: 510
    t.string   "flag",       limit: 510
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_tests", force: :cascade do |t|
    t.string   "code",          limit: 510
    t.string   "name",          limit: 510
    t.text     "description"
    t.integer  "decimals"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.integer  "unit_id"
    t.integer  "procedure"
    t.boolean  "derivation"
    t.boolean  "also_numeric"
    t.boolean  "ratio"
    t.boolean  "range"
    t.boolean  "fraction"
    t.integer  "text_length"
    t.integer  "position"
  end

  add_index "lab_tests", ["code"], name: "index_lab_tests_on_code", using: :btree
  add_index "lab_tests", ["department_id"], name: "index_lab_tests_on_department_id", using: :btree
  add_index "lab_tests", ["position"], name: "index_lab_tests_on_position", using: :btree
  add_index "lab_tests", ["unit_id"], name: "index_lab_tests_on_unit_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "department_id"
    t.integer  "noticeable_id"
    t.string   "noticeable_type", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["noticeable_id", "noticeable_type"], name: "index_notes_on_noticeable_id_and_noticeable_type", using: :btree

  create_table "panels", force: :cascade do |t|
    t.string   "code",        limit: 510
    t.string   "name",        limit: 510
    t.string   "description", limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "procedure"
  end

  add_index "panels", ["code"], name: "index_panels_on_code", using: :btree

  create_table "patients", force: :cascade do |t|
    t.string   "given_name",            limit: 510
    t.string   "middle_name",           limit: 510
    t.string   "family_name",           limit: 510
    t.string   "family_name2",          limit: 510
    t.string   "gender",                limit: 510
    t.date     "birthdate"
    t.string   "identifier",            limit: 510
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "insurance_provider_id"
    t.string   "phone",                 limit: 64
    t.string   "email",                 limit: 128
    t.integer  "animal_type"
    t.string   "policy_number",         limit: 510
  end

  add_index "patients", ["insurance_provider_id"], name: "index_patients_on_insurance_provider_id", using: :btree

  create_table "price_lists", force: :cascade do |t|
    t.string   "name",       limit: 510, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: :cascade do |t|
    t.decimal  "amount",                     precision: 8, scale: 2
    t.integer  "price_list_id",                                      null: false
    t.integer  "priceable_id",                                       null: false
    t.string   "priceable_type", limit: 510,                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["price_list_id"], name: "index_prices_on_price_list_id", using: :btree
  add_index "prices", ["priceable_id", "priceable_type"], name: "index_prices_on_priceable_id_and_priceable_type", using: :btree

  create_table "reference_ranges", force: :cascade do |t|
    t.string   "gender",      limit: 510
    t.integer  "min_age"
    t.integer  "max_age"
    t.string   "age_unit",    limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lab_test_id"
    t.decimal  "min",                     precision: 15, scale: 5
    t.decimal  "max",                     precision: 15, scale: 5
    t.integer  "animal_type"
    t.string   "description", limit: 510
  end

  add_index "reference_ranges", ["lab_test_id"], name: "index_reference_ranges_on_lab_test_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.string   "value",             limit: 510
    t.integer  "lab_test_id"
    t.integer  "accession_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lab_test_value_id"
  end

  add_index "results", ["accession_id"], name: "index_results_on_accession_id", using: :btree
  add_index "results", ["lab_test_id"], name: "index_results_on_lab_test_id", using: :btree
  add_index "results", ["lab_test_value_id"], name: "index_results_on_lab_test_value_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name",       limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["name"], name: "index_units_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 510
    t.string   "email",                  limit: 510
    t.string   "encrypted_password",     limit: 510,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "initials",               limit: 510
    t.string   "language",               limit: 510
    t.datetime "last_request_at"
    t.datetime "last_sign_in_at"
    t.datetime "current_sign_in_at"
    t.string   "last_sign_in_ip",        limit: 510
    t.string   "current_sign_in_ip",     limit: 510
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.string   "first_name",             limit: 64
    t.string   "last_name",              limit: 64
    t.string   "prefix",                 limit: 32
    t.string   "suffix",                 limit: 32
    t.boolean  "admin",                              default: false, null: false
    t.string   "register",               limit: 510
    t.string   "confirmation_token",     limit: 510
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 510
    t.string   "reset_password_token",   limit: 510
    t.datetime "reset_password_sent_at"
    t.string   "remember_token",         limit: 510
    t.datetime "remember_created_at"
    t.string   "unlock_token",           limit: 510
    t.datetime "locked_at"
    t.integer  "failed_attempts",                    default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
