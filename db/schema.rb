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

ActiveRecord::Schema.define(version: 20130915120159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_trgm"

  create_table "choices", force: true do |t|
    t.string   "name",            null: false
    t.integer  "custom_field_id", null: false
    t.integer  "row",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "choices", ["custom_field_id"], name: "index_choices_on_custom_field_id", using: :btree

  create_table "custom_fields", force: true do |t|
    t.string   "type",                        null: false
    t.integer  "field_set_id",                null: false
    t.string   "name",                        null: false
    t.integer  "row",                         null: false
    t.boolean  "enabled_p",    default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_fields", ["field_set_id"], name: "index_custom_fields_on_field_set_id", using: :btree

  create_table "education_levels", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "row",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_sets", force: true do |t|
    t.string   "type",                           null: false
    t.string   "name",                           null: false
    t.string   "description"
    t.integer  "fields_enabled_qty", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "email",              null: false
    t.string   "name_first"
    t.string   "name_last",          null: false
    t.integer  "birth_year"
    t.integer  "education_level_id"
    t.float    "height"
    t.boolean  "male_p",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["education_level_id"], name: "index_people_on_education_level_id", using: :btree

  create_table "string_gists", force: true do |t|
    t.string  "type",            null: false
    t.integer "custom_field_id", null: false
    t.string  "gist",            null: false
    t.integer "parent_id",       null: false
  end

  add_index "string_gists", ["custom_field_id"], name: "index_string_gists_on_custom_field_id", using: :btree

end
