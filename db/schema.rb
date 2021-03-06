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

ActiveRecord::Schema.define(version: 2019_11_04_153333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_ingredients", force: :cascade do |t|
    t.integer "food_id"
    t.integer "ingredient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_food_ingredients_on_food_id"
  end

  create_table "foods", force: :cascade do |t|
    t.bigint "upc"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_warning", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "composition"
    t.string "source"
  end

  create_table "nutrients", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "unit"
    t.boolean "is_limiting", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.string "alias"
    t.integer "sorting_order"
  end

  create_table "nutrition_facts", force: :cascade do |t|
    t.integer "food_id"
    t.integer "nutrient_id"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_nutrition_facts_on_food_id"
  end

  create_table "string_requests", force: :cascade do |t|
    t.string "upc"
    t.string "nutrition_facts_string"
    t.string "ingredients_string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
