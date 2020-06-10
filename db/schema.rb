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

ActiveRecord::Schema.define(version: 2020_06_02_083559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "line1"
    t.string "line2"
    t.string "line3"
    t.string "town_city"
    t.string "county"
    t.string "postcode"
    t.string "udprn"
    t.string "lat"
    t.string "long"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cash_contributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount"
    t.string "description"
    t.integer "secured"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "project_id", null: false
    t.index ["project_id"], name: "index_cash_contributions_on_project_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "evidence_of_support", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "project_id", null: false
    t.index ["project_id"], name: "index_evidence_of_support_on_project_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "funding_application_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "address_id", null: false
    t.uuid "funding_application_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_funding_application_addresses_on_address_id"
    t.index ["funding_application_id"], name: "index_funding_application_addresses_on_funding_application_id"
  end

  create_table "funding_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "declaration"
    t.text "declaration_description"
    t.boolean "declaration_keep_informed"
    t.boolean "declaration_user_research"
    t.string "project_reference_number"
    t.string "salesforce_case_id"
    t.string "salesforce_case_number"
    t.datetime "submitted_on"
    t.uuid "organisation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organisation_id"], name: "index_funding_applications_on_organisation_id"
  end

  create_table "legal_signatories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.string "phone_number"
    t.uuid "organisation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organisation_id"], name: "index_legal_signatories_on_organisation_id"
  end

  create_table "non_cash_contributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "project_id", null: false
    t.index ["project_id"], name: "index_non_cash_contributions_on_project_id"
  end

  create_table "organisations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "line1"
    t.string "townCity"
    t.string "county"
    t.string "postcode"
    t.string "company_number"
    t.string "charity_number"
    t.integer "charity_number_ni"
    t.string "name"
    t.string "line2"
    t.string "line3"
    t.integer "org_type"
    t.string "mission", default: [], array: true
    t.string "salesforce_account_id"
  end

  create_table "project_costs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "cost_type"
    t.integer "amount"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "project_id", null: false
    t.index ["project_id"], name: "index_project_costs_on_project_id"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "project_title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.string "line1"
    t.string "line2"
    t.string "line3"
    t.string "townCity"
    t.string "county"
    t.string "postcode"
    t.text "difference"
    t.text "matter"
    t.text "heritage_description"
    t.text "best_placed_description"
    t.text "involvement_description"
    t.integer "permission_type"
    t.text "permission_description"
    t.boolean "capital_work"
    t.text "declaration_reasons_description"
    t.boolean "user_research_declaration", default: false
    t.boolean "keep_informed_declaration", default: false
    t.boolean "outcome_2"
    t.boolean "outcome_3"
    t.boolean "outcome_4"
    t.boolean "outcome_5"
    t.boolean "outcome_6"
    t.boolean "outcome_7"
    t.boolean "outcome_8"
    t.boolean "outcome_9"
    t.text "outcome_2_description"
    t.text "outcome_3_description"
    t.text "outcome_4_description"
    t.text "outcome_5_description"
    t.text "outcome_6_description"
    t.text "outcome_7_description"
    t.text "outcome_8_description"
    t.text "outcome_9_description"
    t.boolean "is_partnership", default: false
    t.text "partnership_details"
    t.string "salesforce_case_number"
    t.string "salesforce_case_id"
    t.string "project_reference_number"
    t.datetime "submitted_on"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "released_forms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "payload"
    t.integer "form_type"
    t.index ["project_id"], name: "index_released_forms_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "organisation_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.date "date_of_birth"
    t.string "name"
    t.string "line1"
    t.string "line2"
    t.string "line3"
    t.string "townCity"
    t.string "county"
    t.string "postcode"
    t.string "phone_number"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "volunteers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "description"
    t.integer "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "project_id", null: false
    t.index ["project_id"], name: "index_volunteers_on_project_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cash_contributions", "projects"
  add_foreign_key "evidence_of_support", "projects"
  add_foreign_key "funding_application_addresses", "addresses"
  add_foreign_key "funding_application_addresses", "funding_applications"
  add_foreign_key "funding_applications", "organisations"
  add_foreign_key "non_cash_contributions", "projects"
  add_foreign_key "project_costs", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "users", "organisations"
  add_foreign_key "volunteers", "projects"
end
