class Sqaauto409ChangeHeatBeatToHeartbeat < ActiveRecord::Migration
  def up
    say 'SQAAUTO-409 Change Heat Beat to Heartbeat'
    @connection = ActiveRecord::Base.connection

    say 'Update data on Cases table'
    @connection.execute "UPDATE `cases` SET name='INMON Heartbeat Checking' WHERE script_path = '7_HeartBeat/inmon_heartbeat_checking.rb'"
    @connection.execute "UPDATE `cases` SET name='LeapTV Heartbeat Checking' WHERE script_path = '7_HeartBeat/leaptv_heartbeat_checking.rb'"
    @connection.execute "UPDATE `cases` SET name='ATG Heartbeat Checking' WHERE script_path = '7_HeartBeat/atg_heartbeat_checking.rb'"
    @connection.execute "UPDATE `cases` SET script_path = '7_heartbeat/atg_heartbeat_checking.rb' WHERE script_path = '7_HeartBeat/atg_heartbeat_checking.rb'"

    say 'Update data on Suites table'
    @connection.execute "UPDATE `suites` SET name = 'Heartbeat Checking' WHERE id = '49'"
    @connection.execute "UPDATE `suites` SET name = 'ATG Heartbeat Checking' WHERE id = '50'"
  end
end
