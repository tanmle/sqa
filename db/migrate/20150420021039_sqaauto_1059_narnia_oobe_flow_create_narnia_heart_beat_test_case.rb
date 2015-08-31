class Sqaauto1059NarniaOobeFlowCreateNarniaHeartBeatTestCase < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-1059 Narnia OOBE flow - Create narnia heart beat test case'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (381,'Narnia Heartbeat Checking','Narnia Heartbeat Checking for WS endpoints','7_HeartBeat/narnia_heartbeat_checking.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (373,49,381,NULL,NULL,405);"
  end
end
