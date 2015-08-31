class Sqaauto194AddCapacityToScheduleTest < ActiveRecord::Migration
  def up
    say 'Add schedules table'
    create_table "schedules", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.binary   "data"
    t.datetime   "start_date"
    t.integer  "repeat_min"
    t.string "weekly"
    t.integer "status", limit: 3
    t.integer "user_id"
    end
  end
end
