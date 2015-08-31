class Sqaauto561AddEmailRollupConfigurationToDb < ActiveRecord::Migration
  def up
    say 'Add email_rollups table'
    create_table  'email_rollups', force: true do |t|
      t.string    'name'
      t.integer   'repeat_min'
      t.datetime  'start_time'
      t.datetime  'from_time'
      t.string    'emails_list'
      t.integer   'status', limit: 3
      t.integer   'user_id'
    end

    say 'Insert data for \'email_rollups\' table'
    @connection.execute 'INSERT INTO email_rollups VALUES (1, \'Dashboard\', 0, NULL, NULL, NULL, 0, 1)'
    @connection.execute 'INSERT INTO email_rollups VALUES (2, \'Schedules\', 0, NULL, NULL, NULL, 0, 1)'
  end
end
