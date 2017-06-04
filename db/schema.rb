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

ActiveRecord::Schema.define(:version => 20120222210933) do

  create_table "comparisons", :force => true do |t|
    t.integer "reference4"
    t.integer "reference2"
    t.string  "owner"
    t.string  "property"
    t.decimal "sbalance",   :precision => 8, :scale => 2
    t.decimal "obalance",   :precision => 8, :scale => 2, :default => 0.0
    t.string  "indicator"
  end

  create_table "debtor_files", :force => true do |t|
    t.string   "name"
    t.date     "startdate"
    t.date     "enddate"
    t.integer  "feefile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debtors", :force => true do |t|
    t.string   "owner"
    t.integer  "reference"
    t.string   "property"
    t.decimal  "coefficient", :precision => 8, :scale => 5
    t.date     "adate"
    t.string   "subject"
    t.decimal  "fees",        :precision => 8, :scale => 2
    t.decimal  "payments",    :precision => 8, :scale => 2
    t.integer  "feefile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ocmref"
  end

  create_table "extracted_files", :force => true do |t|
    t.string   "name"
    t.date     "startdate"
    t.date     "enddate"
    t.integer  "feefile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extracteds", :force => true do |t|
    t.string   "owner"
    t.integer  "reference"
    t.string   "property"
    t.decimal  "coefficient", :precision => 8, :scale => 5
    t.date     "adate"
    t.string   "subject"
    t.decimal  "fees",        :precision => 8, :scale => 2
    t.decimal  "payments",    :precision => 8, :scale => 2
    t.integer  "feefile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feefiles", :force => true do |t|
    t.string   "feefilename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "enddate"
    t.string   "extractfilename"
    t.date     "extractstartdate"
    t.date     "startdate"
    t.string   "debtorfilename"
    t.date     "debtorstartdate"
  end

  create_table "ocmsummaries", :force => true do |t|
    t.integer  "ref"
    t.string   "property"
    t.string   "owner"
    t.decimal  "balance",    :precision => 10, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string "ftype",     :limit => 50
    t.string "fees_file", :limit => 50
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",               :default => "", :null => false
    t.string   "crypted_password",    :default => "", :null => false
    t.string   "password_salt",       :default => "", :null => false
    t.string   "persistence_token",   :default => "", :null => false
    t.string   "single_access_token", :default => "", :null => false
    t.string   "perishable_token",    :default => "", :null => false
    t.integer  "login_count",         :default => 0,  :null => false
    t.integer  "failed_login_count",  :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  create_table "xrefs", :force => true do |t|
    t.string   "santiagoref"
    t.string   "property"
    t.integer  "ocm4digitcode"
    t.integer  "ocmref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
