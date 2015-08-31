class Sqaauto493AtgAutomationCreateHolidaySoftGoodSmokeTest < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection
    say 'SQAAUTO-493 [Sprint 4] [ATG Automation] Create ATG Soft Good Smoke test suite - Holiday support'

    say 'Insert and Update data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (340,'Pre_Condition soft good smoke test (No add Credit Card)','Soft Goods Pre-Condition (No add Credit Card)','6_soft_good_smoke_test/soft_good_pre_condition_no_credit_card.rb',NULL,NULL);"
    @connection.execute "UPDATE `cases` SET name='Pre_Condition soft good smoke test' WHERE script_path = '6_soft_good_smoke_test/soft_good_pre_condition.rb';"

    say 'Insert data for \'suites\' table'
    @connection.execute "INSERT INTO `suites` VALUES (56,'Holiday Soft Goods Smoke Test','',2,'2014-12-05 14:47:51','2014-12-05 14:47:51',56);"

    say 'Insert data for \'suite_maps\' table'
    @connection.execute "INSERT INTO `suite_maps` VALUES (32,48,56,'2014-12-05 14:47:51','2014-12-05 14:47:51',NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute 'INSERT INTO `case_suite_maps` VALUES (303,56,340,NULL,NULL,300),(304,56,302,NULL,NULL,302),(305,56,305,NULL,NULL,305),(306,56,311,NULL,NULL,311),(307,56,312,NULL,NULL,312);'
  end
end
