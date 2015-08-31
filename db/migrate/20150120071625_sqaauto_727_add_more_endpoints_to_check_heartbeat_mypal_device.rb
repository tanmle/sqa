class Sqaauto727AddMoreEndpointsToCheckHeartbeatMypalDevice < ActiveRecord::Migration
  def up
    say 'SQAAUTO-727 Add more endpoints to check Heartbeat - MyPals device'
    @connection = ActiveRecord::Base.connection

    say 'Update data on "cases" table'
    @connection.execute "INSERT INTO `cases` VALUES (346,'MyPals Heartbeat Checking','MyPals Heartbeat Checking','7_HeartBeat/mypals_heartbeat_checking.rb','2015-01-20 14:18:50','2015-01-20 14:18:50');"

    say 'Update data on "case_suites_map" table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (313,49,346,NULL,NULL,346);"
  end
end
