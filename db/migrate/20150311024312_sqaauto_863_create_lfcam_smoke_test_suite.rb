class Sqaauto863CreateLfcamSmokeTestSuite < ActiveRecord::Migration
  def up
    say 'SQAAUTO-863 Create LFCAM Smoke Test Suite'
    @connection = ActiveRecord::Base.connection

    say "Add new Test Suite into 'suites' table"
    @connection.execute "INSERT INTO `suites` VALUES (59,'INMON LFCAM Smoke Test','INMON LFCAM Smoke Test',1,NULL,NULL,59);"

    say "Add data into 'case_suite_map' table"
    @connection.execute 'INSERT INTO `case_suite_maps` VALUES (326,59,3,NULL,NULL,359),(327,59,8,NULL,NULL,360),(328,59,9,NULL,NULL,361),(329,59,10,NULL,NULL,362),(330,59,35,NULL,NULL,363),(331,59,1,NULL,NULL,364),(332,59,2,NULL,NULL,365),(333,59,322,NULL,NULL,366),(334,59,323,NULL,NULL,367),(335,59,324,NULL,NULL,368),(336,59,325,NULL,NULL,369),(337,59,326,NULL,NULL,370),(338,59,327,NULL,NULL,371),(339,59,328,NULL,NULL,372),(340,59,329,NULL,NULL,373),(341,59,330,NULL,NULL,374),(342,59,331,NULL,NULL,375),(343,59,332,NULL,NULL,376),(344,59,333,NULL,NULL,377),(345,59,334,NULL,NULL,378),(346,59,356,NULL,NULL,379),(347,59,357,NULL,NULL,380),(348,59,358,NULL,NULL,381);'
  end
end
