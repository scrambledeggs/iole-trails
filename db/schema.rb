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

ActiveRecord::Schema[7.0].define(version: 2022_11_23_034249) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "body_build"
    t.float "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practices", force: :cascade do |t|
    t.integer "status", default: 0
    t.bigint "person_id", null: false
    t.bigint "trail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_practices_on_person_id"
    t.index ["trail_id"], name: "index_practices_on_trail_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.datetime "start"
    t.datetime "end"
    t.float "duration"
    t.integer "winner"
    t.bigint "trail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_races_on_trail_id"
  end

  create_table "runs", force: :cascade do |t|
    t.integer "status", default: 0
    t.float "duration"
    t.integer "place"
    t.bigint "person_id", null: false
    t.bigint "race_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_runs_on_person_id"
    t.index ["race_id"], name: "index_runs_on_race_id"
  end

  create_table "trails", force: :cascade do |t|
    t.string "name"
    t.integer "age_minimum"
    t.integer "age_maximum"
    t.integer "body_build"
    t.float "weight_minimum"
    t.float "weight_maximum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "practices", "people"
  add_foreign_key "practices", "trails"
  add_foreign_key "races", "trails"
  add_foreign_key "runs", "people"
  add_foreign_key "runs", "races"
end
