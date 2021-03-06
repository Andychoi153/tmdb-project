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

ActiveRecord::Schema.define(version: 2019_05_18_125430) do

  create_table "movie_credits", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "movie_id"
    t.bigint "person_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "person_id"], name: "movie_person_match", unique: true
    t.index ["movie_id"], name: "index_movie_credits_on_movie_id"
    t.index ["person_id"], name: "index_movie_credits_on_person_id"
  end

  create_table "movies", primary_key: "movie_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "poster_path"
    t.float "vote_average"
    t.integer "vote_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", primary_key: "person_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "profile_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tv_credits", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "tv_id"
    t.bigint "person_id"
    t.integer "season_number"
    t.integer "episode_number"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_tv_credits_on_person_id"
    t.index ["tv_id", "season_number", "episode_number", "person_id"], name: "tv_episode_person_match", unique: true
    t.index ["tv_id"], name: "index_tv_credits_on_tv_id"
  end

  create_table "tv_episodes", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "tv_id"
    t.integer "season_number"
    t.integer "episode_number"
    t.string "still_path"
    t.float "vote_average"
    t.integer "vote_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tv_id", "episode_number"], name: "tv_episode_match"
    t.index ["tv_id", "season_number", "episode_number"], name: "season_episode_match", unique: true
    t.index ["tv_id"], name: "index_tv_episodes_on_tv_id"
  end

  create_table "tv_seasons", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "tv_id"
    t.integer "season_number"
    t.string "poster_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tv_id", "season_number"], name: "tv_season_match", unique: true
    t.index ["tv_id"], name: "index_tv_seasons_on_tv_id"
  end

  create_table "tvs", primary_key: "tv_id", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "poster_path"
    t.float "vote_average"
    t.integer "vote_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
