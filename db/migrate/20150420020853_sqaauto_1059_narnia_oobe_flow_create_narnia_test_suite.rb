class Sqaauto1059NarniaOobeFlowCreateNarniaTestSuite < ActiveRecord::Migration
  def up
    say 'SQAAUTO-1059 Create Narnia Test Suite'
    @connection = ActiveRecord::Base.connection

    say "Add new Test Suite into 'suites' table"
    @connection.execute "INSERT INTO `suites` VALUES (63,'Narnia','Narnia test suite',1,NULL, NULL, 62);"

    say "Add new Test Case into 'cases' table"
    @connection.execute "INSERT INTO `cases` VALUES (378,'Narnia sso api','add narnia sso api script','8_Narnia/ts01_narnia_sso_api.rb',NULL,NULL),(379,'Narnia device and profile api','add Narnia device and profile api script','8_Narnia/ts02_narnia_device_profile_api.rb',NULL,NULL),(380,'Narnia play data log upload api','add Narnia play data log upload script','8_Narnia/ts03_narnia_play_data_log_upload_api.rb',NULL,NULL);"

    say "Add data into 'case_suite_map' table"
    @connection.execute 'INSERT INTO `case_suite_maps` VALUES (369,63,377,NULL,NULL,402),(370,63,378,NULL,NULL,402),(371,63,379,NULL,NULL,403),(372,63,380,NULL,NULL,404);'
  end
end
