class Sqaauto864WsSmokeTestAddJumpBogotaGlasgow < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-864 WS Smoke Test - Add Jump, Bogota, Glasgow'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (356,'OOBE Smoke Test - Jump','Smoke test Jump','2_SmokeTest/ts18_smoke_test_oobe_Jump.rb',NULL,NULL),(357,'OOBE Smoke Test - Bogota','Smoke test Bogota','2_SmokeTest/ts19_smoke_test_oobe_Bogota.rb',NULL,NULL),(358,'OOBE Smoke Test - Glasgow','Smoke test Glasgow','2_SmokeTest/ts20_smoke_test_oobe_Glasgow.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (323,24,356,NULL,NULL,356),(324,24,357,NULL,NULL,357),(325,24,358,NULL,NULL,358);"
  end
end
