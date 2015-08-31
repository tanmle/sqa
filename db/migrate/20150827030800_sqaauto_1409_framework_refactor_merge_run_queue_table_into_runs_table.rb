class Sqaauto1409FrameworkRefactorMergeRunQueueTableIntoRunsTable < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1409 Framework - refactor - merge run queue table into runs table'

    say 'Create status (queued|running|done) and location columns'
    add_column :runs, :status, :string, limit: 15, null: false
    add_column :runs, :location, :string, limit: 50

    say 'Migrate the run_queues data to runs'
    connection = ActiveRecord::Base.connection
    connection.execute <<-SQL.strip_heredoc
      INSERT INTO runs (user_id, data, location, created_at, updated_at, status)
      SELECT user_id, data, location, created_at, updated_at, 'queued' FROM run_queues;
    SQL

    say 'SQAAUTO-1409 Framework - refactor - merge run queue table into runs table'

    say 'Drop the run_queues table'
    drop_table :run_queues

    say 'Change status from NULL to \'done\''
    connection.execute 'UPDATE runs SET status=\'done\' WHERE TRIM(status) = \'\' '
  end

  def down
    say 'Create run_queues table'
    create_table 'run_queues' do |t|
      t.integer  'user_id',    limit: 4
      t.text     'data',       limit: -1
      t.string   'location',   limit: 255
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    say 'Move \'queued\' into \'run_queues\''
    connection = ActiveRecord::Base.connection
    connection.execute <<-SQL.strip_heredoc
      INSERT INTO run_queues (user_id, data, location, created_at, updated_at)
      SELECT user_id, data, location, created_at, updated_at FROM runs
      WHERE status = 'queued';
    SQL
    connection.execute 'DELETE FROM runs WHERE status = \'queued\';'

    say 'Remove status and location columns'
    remove_column :runs, :status
    remove_column :runs, :location
  end
end
