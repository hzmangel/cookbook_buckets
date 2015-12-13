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

ActiveRecord::Schema.define(version: 20151208133154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cookbooks", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.string   "desc"
    t.string   "gdoc_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cookbooks", ["name"], name: "index_cookbooks_on_name", using: :btree

  create_table "cookbooks_tags", id: false, force: :cascade do |t|
    t.integer "cookbook_id"
    t.integer "tag_id"
  end

  add_index "cookbooks_tags", ["cookbook_id"], name: "index_cookbooks_tags_on_cookbook_id", using: :btree
  add_index "cookbooks_tags", ["tag_id"], name: "index_cookbooks_tags_on_tag_id", using: :btree

  create_table "material_quantities", force: :cascade do |t|
    t.integer  "material_id"
    t.integer  "cookbook_id"
    t.string   "unit"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "material_quantities", ["cookbook_id"], name: "index_material_quantities_on_cookbook_id", using: :btree
  add_index "material_quantities", ["material_id"], name: "index_material_quantities_on_material_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "materials", ["name"], name: "index_materials_on_name", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

end
