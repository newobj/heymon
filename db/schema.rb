# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090423194921) do

  create_table "alarm_defs", :force => true do |t|
    t.string   "host",                                       :null => false
    t.string   "plugin",                                     :null => false
    t.string   "type",                                       :null => false
    t.string   "data_source",                                :null => false
    t.string   "warning_range",                              :null => false
    t.string   "critical_range",                             :null => false
    t.string   "message_format",                             :null => false
    t.string   "action",                                     :null => false
    t.boolean  "disabled",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "critical_duration_threshold", :default => 0, :null => false
    t.integer  "warning_duration_threshold",  :default => 0, :null => false
  end

  create_table "alarms", :force => true do |t|
    t.string   "severity",            :null => false
    t.string   "host",                :null => false
    t.string   "plugin",              :null => false
    t.string   "type",                :null => false
    t.string   "data_source",         :null => false
    t.string   "value",               :null => false
    t.integer  "def_id",              :null => false
    t.string   "message",             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "entered_critical_at"
    t.datetime "entered_warning_at"
  end

  create_table "dashboards", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "grp",        :null => false
    t.binary   "query",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
