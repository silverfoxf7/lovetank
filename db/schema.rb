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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110406104739) do

  create_table "bids", :force => true do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "jobpost_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bids", ["jobpost_id"], :name => "index_bids_on_jobpost_id"
  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "jobposts", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.string   "poster"
    t.text     "description"
    t.string   "work_type"
    t.float    "max_budget"
    t.integer  "duration"
    t.string   "skills"
    t.datetime "expiretime"
    t.datetime "start_date"
    t.boolean  "overtime"
    t.integer  "work_intensity"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "jobposts", ["description"], :name => "index_jobposts_on_description"
  add_index "jobposts", ["duration"], :name => "index_jobposts_on_duration"
  add_index "jobposts", ["expiretime"], :name => "index_jobposts_on_expiretime"
  add_index "jobposts", ["location"], :name => "index_jobposts_on_location"
  add_index "jobposts", ["max_budget"], :name => "index_jobposts_on_max_budget"
  add_index "jobposts", ["overtime"], :name => "index_jobposts_on_overtime"
  add_index "jobposts", ["poster"], :name => "index_jobposts_on_poster"
  add_index "jobposts", ["skills"], :name => "index_jobposts_on_skills"
  add_index "jobposts", ["start_date"], :name => "index_jobposts_on_start_date"
  add_index "jobposts", ["title"], :name => "index_jobposts_on_title"
  add_index "jobposts", ["user_id"], :name => "index_jobposts_on_user_id"
  add_index "jobposts", ["work_intensity"], :name => "index_jobposts_on_work_intensity"
  add_index "jobposts", ["work_type"], :name => "index_jobposts_on_work_type"

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id"], :name => "index_microposts_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "real_name"
    t.integer  "status"
    t.text     "skills"
    t.string   "location"
    t.integer  "rating"
    t.integer  "jobs_completed"
    t.text     "tagline"
    t.string   "skill1"
    t.string   "skill2"
    t.string   "skill3"
    t.text     "resume"
    t.integer  "account_type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "winationships", :force => true do |t|
    t.integer  "job_id"
    t.integer  "worker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "winationships", ["job_id", "worker_id"], :name => "index_winationships_on_job_id_and_worker_id", :unique => true
  add_index "winationships", ["job_id"], :name => "index_winationships_on_job_id"
  add_index "winationships", ["worker_id"], :name => "index_winationships_on_worker_id"

end
