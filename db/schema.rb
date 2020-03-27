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

ActiveRecord::Schema.define(version: 2020_03_27_191345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dialers", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "did"
    t.string "conference_code"
    t.datetime "assigned_at"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_dialers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "last_names"
    t.string "email"
    t.string "phone", null: false
    t.integer "status", default: 0
    t.string "activation_code"
    t.integer "target", null: false
    t.string "business_name", null: false
    t.integer "industry", default: 0
    t.integer "state", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "dialers", "users"
end
