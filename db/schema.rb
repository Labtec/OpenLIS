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

  create_table "accession_panels", force: true do |t|
    t.integer  "accession_id"
    t.integer  "panel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accession_panels", ["accession_id", "panel_id"], name: "index_accession_panels_on_accession_id_and_panel_id"

  create_table "accessions", force: true do |t|
    t.integer  "patient_id"
    t.datetime "drawn_at"
    t.integer  "drawer_id"
    t.datetime "received_at"
    t.integer  "receiver_id"
    t.datetime "reported_at"
    t.integer  "reporter_id"
    t.integer  "doctor_id"
    t.string   "icd9"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accessions", ["doctor_id"], name: "index_accessions_on_doctor_id"
  add_index "accessions", ["drawer_id"], name: "index_accessions_on_drawer_id"
  add_index "accessions", ["patient_id"], name: "index_accessions_on_patient_id"
  add_index "accessions", ["receiver_id"], name: "index_accessions_on_receiver_id"
  add_index "accessions", ["reporter_id"], name: "index_accessions_on_reporter_id"

  create_table "claims", force: true do |t|
    t.integer  "accession_id"
    t.string   "number"
    t.string   "external_number"
    t.datetime "claimed_at"
    t.integer  "insurance_provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "claims", ["accession_id"], name: "index_claims_on_accession_id", unique: true
  add_index "claims", ["insurance_provider_id"], name: "index_claims_on_insurance_provider_id"

  create_table "departments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["name"], name: "index_departments_on_name", unique: true

  create_table "doctors", force: true do |t|
    t.string   "name"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctors", ["name"], name: "index_doctors_on_name"

  create_table "insurance_providers", force: true do |t|
    t.string   "name"
    t.integer  "price_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insurance_providers", ["price_list_id"], name: "index_insurance_providers_on_price_list_id"

  create_table "lab_test_panels", force: true do |t|
    t.integer  "lab_test_id"
    t.integer  "panel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lab_test_panels", ["lab_test_id", "panel_id"], name: "index_lab_test_panels_on_lab_test_id_and_panel_id"

  create_table "lab_test_value_option_joints", force: true do |t|
    t.integer  "lab_test_value_id"
    t.integer  "lab_test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_test_values", force: true do |t|
    t.string   "value"
    t.string   "flag"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_tests", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.integer  "decimals"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lab_tests", ["code"], name: "index_lab_tests_on_code", unique: true
  add_index "lab_tests", ["department_id"], name: "index_lab_tests_on_department_id"
  add_index "lab_tests", ["position"], name: "index_lab_tests_on_position"
  add_index "lab_tests", ["unit_id"], name: "index_lab_tests_on_unit_id"

  create_table "notes", force: true do |t|
    t.text     "content"
    t.integer  "department_id"
    t.integer  "noticeable_id"
    t.string   "noticeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["noticeable_id", "noticeable_type"], name: "index_notes_on_noticeable_id_and_noticeable_type"

  create_table "panels", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.integer  "procedure"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "panels", ["code"], name: "index_panels_on_code"

  create_table "patients", force: true do |t|
    t.string   "given_name"
    t.string   "middle_name"
    t.string   "family_name"
    t.string   "family_name2"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "identifier"
    t.text     "address"
    t.integer  "insurance_provider_id"
    t.string   "phone",                 limit: 32
    t.string   "email",                 limit: 64
    t.integer  "animal_type"
    t.string   "policy_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patients", ["family_name"], name: "index_patients_on_family_name"
  add_index "patients", ["family_name2"], name: "index_patients_on_family_name2"
  add_index "patients", ["given_name"], name: "index_patients_on_given_name"
  add_index "patients", ["identifier"], name: "index_patients_on_identifier"
  add_index "patients", ["insurance_provider_id"], name: "index_patients_on_insurance_provider_id"
  add_index "patients", ["middle_name"], name: "index_patients_on_middle_name"

  create_table "price_lists", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: true do |t|
    t.decimal  "amount",         precision: 8, scale: 2
    t.integer  "price_list_id",                          null: false
    t.integer  "priceable_id",                           null: false
    t.string   "priceable_type",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["price_list_id"], name: "index_prices_on_price_list_id"
  add_index "prices", ["priceable_id", "priceable_type"], name: "index_prices_on_priceable_id_and_priceable_type"

  create_table "reference_ranges", force: true do |t|
    t.decimal  "min",         precision: 10, scale: 5
    t.decimal  "max",         precision: 10, scale: 5
    t.string   "gender"
    t.integer  "min_age"
    t.integer  "max_age"
    t.string   "age_unit"
    t.integer  "lab_test_id"
    t.integer  "animal_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_ranges", ["lab_test_id"], name: "index_reference_ranges_on_lab_test_id"

  create_table "results", force: true do |t|
    t.string   "value"
    t.integer  "lab_test_id"
    t.integer  "accession_id"
    t.integer  "lab_test_value_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["accession_id"], name: "index_results_on_accession_id"
  add_index "results", ["lab_test_id"], name: "index_results_on_lab_test_id"
  add_index "results", ["lab_test_value_id"], name: "index_results_on_lab_test_value_id"

  create_table "units", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["name"], name: "index_units_on_name"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password",                                 null: false
    t.string   "initials"
    t.string   "language"
    t.datetime "last_request_at"
    t.datetime "last_sign_in_at"
    t.datetime "current_sign_in_at"
    t.string   "last_sign_in_ip"
    t.string   "current_sign_in_ip"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.string   "first_name",             limit: 32
    t.string   "last_name",              limit: 32
    t.string   "prefix",                 limit: 16
    t.string   "suffix",                 limit: 16
    t.boolean  "admin",                              default: false, null: false
    t.string   "register"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.integer  "failed_attempts",                    default: 0
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
