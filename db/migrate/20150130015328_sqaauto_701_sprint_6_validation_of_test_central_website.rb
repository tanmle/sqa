class Sqaauto701Sprint6ValidationOfTestCentralWebsite < ActiveRecord::Migration
  def up
    say 'SQAAUTO-701 [Sprint_6] Validation of TestCentral website'
    @connection = ActiveRecord::Base.connection

    say "Add new Test Suite into 'suites' table"
    @connection.execute "INSERT INTO `suites` VALUES (58,'Unit Tests','Unit Tests for Test Central',4,NULL, NULL, 1);"

    say "Add new Test Case into 'cases' table"
    @connection.execute "INSERT INTO `cases` VALUES (347,'Add new run queues','Add new some run queues into run queues table','models/add_new_run_queues.rb',NULL,NULL),(348,'Add new schedule','Add new some schedules into schedules table ','models/add_new_schedules.rb',NULL,NULL),(349,'Create new user account','Test create new user account','models/create_user_account.rb',NULL,NULL),(350,'Update user account','Update user account','models/update_user_account.rb',NULL,NULL),(351,'Config limit test run','Config limit test run','models/config_limit_test_run.rb',NULL,NULL),(352,'Config smtp','Config smtp','models/config_smtp.rb',NULL,NULL),(353,'Dashboard email rollup config','Dashboard email rollup config','models/dashboard_email_rollup_config.rb',NULL,NULL),(354,'Schedules email rollup config','Schedules email rollup config','models/schedules_email_rollup_config.rb',NULL,NULL),(355,'Refresh environments version','Refresh environments version then updating into database','models/refresh_environment_version.rb',NULL,NULL);"

    say "Add data into 'case_suite_map' table"
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (314,58,347,NULL,NULL,347),(315,58,348,NULL,NULL,348),(316,58,349,NULL,NULL,349),(317,58,350,NULL,NULL,350),(318,58,351,NULL,NULL,351),(319,58,352,NULL,NULL,352),(320,58,353,NULL,NULL,353),(321,58,354,NULL,NULL,354),(322,58,355,NULL,NULL,355);"
  end
end
