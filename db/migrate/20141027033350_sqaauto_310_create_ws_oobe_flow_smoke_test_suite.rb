class Sqaauto310CreateWsOobeFlowSmokeTestSuite < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-310 Create WS/INMON (OOBE flow) Smoke Test Suite'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (322,'OOBE Smoke Test - LeapPad Ultra',NULL,'2_SmokeTest/ts05_smoke_test_oobe_RIO.rb',NULL,NULL),(323,'OOBE Smoke Test - LeapPad Explorer ',NULL,'2_SmokeTest/ts06_smoke_test_oobe_LPAD.rb',NULL,NULL),(324,'OOBE Smoke Test - LeapPad 2 Explorer ',NULL,'2_SmokeTest/ts07_smoke_test_oobe_LPAD2.rb',NULL,NULL),(325,'OOBE Smoke Test - Leapster Explorer',NULL,'2_SmokeTest/ts08_smoke_test_oobe_LEX.rb',NULL,NULL),(326,'OOBE Smoke Test - Leapster GS Explorer ',NULL,'2_SmokeTest/ts09_smoke_test_oobe_LeapsterGS.rb',NULL,NULL),(327,'OOBE Smoke Test - Leapster 2',NULL,'2_SmokeTest/ts10_smoke_test_oobe_Leapster2.rb',NULL,NULL),(328,'OOBE Smoke Test - LeapReader',NULL,'2_SmokeTest/ts11_smoke_test_oobe_LeapReader.rb',NULL,NULL),(329,'OOBE Smoke Test - Djdj',NULL,'2_SmokeTest/ts12_smoke_test_oobe_Didj.rb',NULL,NULL),(330,'OOBE Smoke Test - Tag',NULL,'2_SmokeTest/ts13_smoke_test_oobe_Tag.rb',NULL,NULL),(331,'OOBE Smoke Test - Crammer',NULL,'2_SmokeTest/ts14_smoke_test_oobe_Crammer.rb',NULL,NULL),(332,'OOBE Smoke Test - MOSTP',NULL,'2_SmokeTest/ts15_smoke_test_oobe_MOSTP.rb',NULL,NULL),(333,'OOBE Smoke Test - My LeapTop',NULL,'2_SmokeTest/ts16_smoke_test_oobe_MyLeapTop.rb',NULL,NULL),(334,'OOBE Smoke Test - My Pals',NULL,'2_SmokeTest/ts17_smoke_test_oobe_MyPals.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (270,24,322,NULL,NULL,322),(271,24,323,NULL,NULL,323),(272,24,324,NULL,NULL,324),(273,24,325,NULL,NULL,325),(274,24,326,NULL,NULL,326),(275,24,327,NULL,NULL,327),(276,24,328,NULL,NULL,328),(277,24,329,NULL,NULL,329),(278,24,330,NULL,NULL,330),(279,24,331,NULL,NULL,331),(280,24,332,NULL,NULL,332),(281,24,333,NULL,NULL,333),(282,24,334,NULL,NULL,334);"
  end
end
