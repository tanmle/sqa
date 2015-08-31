class Sqaauto1198InmonLfcamSmokeTestTestsuiteAddCaboOobeSmokeTest < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1198 INMON LFCAM Smoke Test (Suite) - add Cabo OOBE Smoke Test'
    @connection = ActiveRecord::Base.connection

    say "Add data into 'case_suite_map' table"
    @connection.execute 'INSERT INTO `case_suite_maps` VALUES (375,59,382,NULL,NULL,407)'
  end
end
