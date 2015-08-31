class Sqaauto198HeartbeatInmonTestSuite < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-198 Heartbeat-INMON test suite'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (317,'INMON Heat Beat Checking',NULL,'7_HeartBeat/inmon_heartbeat_checking.rb',NULL,NULL),(318,'LeapTV Heat Beat Checking',NULL,'7_HeartBeat/leaptv_heartbeat_checking.rb',NULL,NULL),(319,'ATG Heat Beat Checking',NULL,'7_HeartBeat/atg_heartbeat_checking.rb',NULL,NULL);"

    say 'Insert data for \'suites\' table'
    @connection.execute "INSERT INTO `suites` VALUES (49,'WS Heart Beat','INMON, LeapTV Heart Beat checking',1,NULL,NULL,49),(50,'ATG Heat Beat','ATG Heart Beat checking',2,NULL,NULL,50);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (264,49,317,NULL,NULL,317),(265,49,318,NULL,NULL,318),(266,50,319,NULL,NULL,319);"
  end
end
