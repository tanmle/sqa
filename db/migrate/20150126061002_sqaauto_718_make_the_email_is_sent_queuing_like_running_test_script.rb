class Sqaauto718MakeTheEmailIsSentQueuingLikeRunningTestScript < ActiveRecord::Migration
  def up
    say "Create 'email_queues' table"
    create_table :email_queues do |t|
      t.integer 'run_id'
      t.string 'email_list', limit: 1000
      t.datetime 'created_at'
    end
  end

  def down
    say "Drop 'email_queues' table"
    drop_table :email_queues
  end
end
