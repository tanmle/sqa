class Sqaauto1059Q1S9NarniaOobeFlowAddToLfcamTs < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1059 [Q1_S9] Narnia OOBE flow'
    @connection = ActiveRecord::Base.connection

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (377,'OOBE Smoke Test - Narnia','Smoke test Narnia','2_SmokeTest/ts21_smoke_test_oobe_Narnia.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (367,59,377,NULL,NULL,400),(368,24,377,NULL,NULL,401);"
  end
end
