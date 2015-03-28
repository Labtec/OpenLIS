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

ActiveRecord::Schema.define(version: 20141003113152) do

  create_table "accession_panels", force: :cascade do |t|
    t.integer  "accession_id", limit: 4
    t.integer  "panel_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accession_panels", ["accession_id", "panel_id"], name: "index_accession_panels_on_accession_id_and_panel_id", using: :btree

  create_table "accessions", force: :cascade do |t|
    t.integer  "patient_id",  limit: 4
    t.datetime "drawn_at"
    t.integer  "drawer_id",   limit: 4
    t.datetime "received_at"
    t.integer  "receiver_id", limit: 4
    t.datetime "reported_at"
    t.integer  "reporter_id", limit: 4
    t.integer  "doctor_id",   limit: 4
    t.string   "icd9",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accessions", ["doctor_id"], name: "index_accessions_on_doctor_id", using: :btree
  add_index "accessions", ["drawer_id"], name: "index_accessions_on_drawer_id", using: :btree
  add_index "accessions", ["patient_id"], name: "index_accessions_on_patient_id", using: :btree
  add_index "accessions", ["receiver_id"], name: "index_accessions_on_receiver_id", using: :btree
  add_index "accessions", ["reporter_id"], name: "index_accessions_on_reporter_id", using: :btree

  create_table "claims", force: :cascade do |t|
    t.integer  "accession_id",          limit: 4
    t.string   "number",                limit: 255
    t.string   "external_number",       limit: 255
    t.datetime "claimed_at"
    t.integer  "insurance_provider_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "claims", ["accession_id"], name: "index_claims_on_accession_id", unique: true, using: :btree
  add_index "claims", ["insurance_provider_id"], name: "index_claims_on_insurance_provider_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["name"], name: "index_departments_on_name", unique: true, using: :btree

  create_table "doctors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "gender",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctors", ["name"], name: "index_doctors_on_name", using: :btree

  create_table "insurance_providers", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "price_list_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insurance_providers", ["price_list_id"], name: "index_insurance_providers_on_price_list_id", using: :btree

  create_table "lab_test_panels", force: :cascade do |t|
    t.integer  "lab_test_id", limit: 4
    t.integer  "panel_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lab_test_panels", ["lab_test_id", "panel_id"], name: "index_lab_test_panels_on_lab_test_id_and_panel_id", using: :btree

  create_table "lab_test_value_option_joints", force: :cascade do |t|
    t.integer  "lab_test_value_id", limit: 4
    t.integer  "lab_test_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_test_values", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.string   "flag",       limit: 255
    t.text     "note",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_tests", force: :cascade do |t|
    t.string   "code",          limit: 255
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.integer  "decimals",      limit: 4
    t.integer  "department_id", limit: 4
    t.integer  "unit_id",       limit: 4
    t.integer  "procedure",     limit: 4
    t.boolean  "derivation"
    t.boolean  "also_numeric"
    t.boolean  "ratio"
    t.boolean  "range"
    t.boolean  "fraction"
    t.integer  "text_length",   limit: 4
    t.integer  "position",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lab_tests", ["code"], name: "index_lab_tests_on_code", unique: true, using: :btree
  add_index "lab_tests", ["department_id"], name: "index_lab_tests_on_department_id", using: :btree
  add_index "lab_tests", ["position"], name: "index_lab_tests_on_position", using: :btree
  add_index "lab_tests", ["unit_id"], name: "index_lab_tests_on_unit_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.text     "content",         limit: 65535
    t.integer  "department_id",   limit: 4
    t.integer  "noticeable_id",   limit: 4
    t.string   "noticeable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["noticeable_id", "noticeable_type"], name: "index_notes_on_noticeable_id_and_noticeable_type", using: :btree

  create_table "panels", force: :cascade do |t|
    t.string   "code",        limit: 255
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "procedure",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "panels", ["code"], name: "index_panels_on_code", using: :btree

  create_table "patients", force: :cascade do |t|
    t.string   "given_name",            limit: 255
    t.string   "middle_name",           limit: 255
    t.string   "family_name",           limit: 255
    t.string   "family_name2",          limit: 255
    t.string   "gender",                limit: 255
    t.date     "birthdate"
    t.string   "identifier",            limit: 255
    t.text     "address",               limit: 65535
    t.integer  "insurance_provider_id", limit: 4
    t.string   "phone",                 limit: 32
    t.string   "email",                 limit: 64
    t.integer  "animal_type",           limit: 4
    t.string   "policy_number",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patients", ["family_name"], name: "index_patients_on_family_name", using: :btree
  add_index "patients", ["family_name2"], name: "index_patients_on_family_name2", using: :btree
  add_index "patients", ["given_name"], name: "index_patients_on_given_name", using: :btree
  add_index "patients", ["identifier"], name: "index_patients_on_identifier", using: :btree
  add_index "patients", ["insurance_provider_id"], name: "index_patients_on_insurance_provider_id", using: :btree
  add_index "patients", ["middle_name"], name: "index_patients_on_middle_name", using: :btree

  create_table "price_lists", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: :cascade do |t|
    t.decimal  "amount",                     precision: 8, scale: 2
    t.integer  "price_list_id",  limit: 4,                           null: false
    t.integer  "priceable_id",   limit: 4,                           null: false
    t.string   "priceable_type", limit: 255,                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["price_list_id"], name: "index_prices_on_price_list_id", using: :btree
  add_index "prices", ["priceable_id", "priceable_type"], name: "index_prices_on_priceable_id_and_priceable_type", using: :btree

  create_table "reference_ranges", force: :cascade do |t|
    t.decimal  "min",                     precision: 10, scale: 5
    t.decimal  "max",                     precision: 10, scale: 5
    t.string   "gender",      limit: 255
    t.integer  "min_age",     limit: 4
    t.integer  "max_age",     limit: 4
    t.string   "age_unit",    limit: 255
    t.integer  "lab_test_id", limit: 4
    t.integer  "animal_type", limit: 4
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_ranges", ["lab_test_id"], name: "index_reference_ranges_on_lab_test_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.string   "value",             limit: 255
    t.integer  "lab_test_id",       limit: 4
    t.integer  "accession_id",      limit: 4
    t.integer  "lab_test_value_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["accession_id"], name: "index_results_on_accession_id", using: :btree
  add_index "results", ["lab_test_id"], name: "index_results_on_lab_test_id", using: :btree
  add_index "results", ["lab_test_value_id"], name: "index_results_on_lab_test_value_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["name"], name: "index_units_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255
    t.string   "email",                  limit: 255
    t.string   "encrypted_password",     limit: 255,                 null: false
    t.string   "initials",               limit: 255
    t.string   "language",               limit: 255
    t.datetime "last_request_at"
    t.datetime "last_sign_in_at"
    t.datetime "current_sign_in_at"
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "current_sign_in_ip",     limit: 255
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.string   "first_name",             limit: 32
    t.string   "last_name",              limit: 32
    t.string   "prefix",                 limit: 16
    t.string   "suffix",                 limit: 16
    t.boolean  "admin",                              default: false, null: false
    t.string   "register",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.integer  "failed_attempts",        limit: 4,   default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
