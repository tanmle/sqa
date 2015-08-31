class Sqaauto628CreateNewTestCentralSilo < ActiveRecord::Migration
  def up
    say 'SQAAUTO-628 Create new TestCentral "TC" silo'
    @connection = ActiveRecord::Base.connection

    say "Add new TestCentral silo into 'silos' table"
    @connection.execute "INSERT INTO `silos` VALUES (4,'TC','Test Central',NULL,'2014-12-25 18:24:19','2014-12-25 18:24:19');"

    say "Add new Test Suite into 'suites' table"
    @connection.execute "INSERT INTO `suites` VALUES (57,'SelfCheck','TestCentral Self Check ',4,'2014-12-25 18:45:51','2014-12-25 18:45:51',1);"

    say "Add new Test Case into 'cases' table"
    @connection.execute "INSERT INTO `cases` VALUES (341,'Routers/Links checking','Check all routers/links','selfcheck/routers_links_checking.rb','2014-12-25 18:28:50','2014-12-25 18:28:50'),(342,'FailFast','FailFast test case that always fails - rspec written to return immediate FAIL result ','selfcheck/fail_fast.rb','2014-12-25 18:28:50','2014-12-25 18:28:50'),(343,'PassFast','PassFast test case that always passes - rspec written to return immediate PASS result','selfcheck/pass_fast.rb','2014-12-25 18:28:50','2014-12-25 18:28:50'),(344,'ExecFail','ExecFail test case that the execution fails and results in a N/A status - invalid test','selfcheck/exec_fail.rb','2014-12-25 18:28:50','2014-12-25 18:28:50'),(345,'MixResults','MixResult test case (include both pass, fail, pending)','selfcheck/mix_results.rb','2014-12-25 18:28:50','2014-12-25 18:28:50');"

    say "Add data into 'case_suite_map' table"
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (308,57,341,NULL,NULL,341),(309,57,342,NULL,NULL,342),(310,57,343,NULL,NULL,343),(311,57,344,NULL,NULL,344),(312,57,345,NULL,NULL,345);"
  end
end
