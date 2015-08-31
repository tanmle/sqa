class SqaautoCreateNewRunQueueTable < ActiveRecord::Migration
  def up
    say "Create 'run_queues' table"
    create_table :run_queues do |t|
      t.integer "user_id"
      t.binary "data"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    say "Drop 'run_queues' table"
    drop_table :run_queues
  end
end
