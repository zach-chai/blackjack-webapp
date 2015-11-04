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

ActiveRecord::Schema.define(version: 20151104220602) do

  create_table "cards", force: :cascade do |t|
    t.string   "suit",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "game_id"
    t.integer  "player_id"
    t.boolean  "hidden",                 default: false
    t.string   "split_hand", limit: 255
  end

  add_index "cards", ["game_id"], name: "index_cards_on_game_id"
  add_index "cards", ["player_id"], name: "index_cards_on_player_id"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "round",      default: 0
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "game_id"
    t.boolean  "has_turn",                 default: false
    t.boolean  "has_split"
    t.boolean  "left_turn"
    t.boolean  "right_turn"
    t.boolean  "stayed",                   default: false
    t.boolean  "left_stayed",              default: false
    t.boolean  "right_stayed",             default: false
    t.integer  "score"
    t.boolean  "charlie"
    t.boolean  "human",                    default: true
    t.integer  "left_score"
    t.integer  "right_score"
    t.integer  "alive",                    default: 0
    t.string   "result",       limit: 255
    t.integer  "rank"
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"

end
