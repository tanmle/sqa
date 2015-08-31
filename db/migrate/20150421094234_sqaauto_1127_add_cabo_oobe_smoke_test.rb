class Sqaauto1127AddCaboOobeSmokeTest < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-1127 Add Cabo OOBE smoke test'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (382,'OOBE Smoke Test - Cabo','Smoke test Cabo','2_SmokeTest/ts22_smoke_test_oobe_Cabo.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (374,24,382,NULL,NULL,406);"
  end
end
