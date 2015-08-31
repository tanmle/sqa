class Sqaauto378CreateAtgHolidayHardGoodsSmokeTest < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection
    say 'SQAAUTO-378 [Sprint_3] Create ATG Holiday Hard Goods Smoke Test'

    say 'Insert and Update data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (339,'Pre_Condition (No add Credit Card)','Hard Goods Pre-Condition (No add Credit Card)','1_smoke_test/pre_condition_no_credit_card.rb',NULL,NULL);"
    @connection.execute "UPDATE `cases` SET name='Pre_Condition' WHERE script_path = '1_smoke_test/pre_condition.rb';"

    say 'Insert data for \'suites\' table'
    @connection.execute "INSERT INTO `suites` VALUES (55,'Holiday Hard Goods Smoke Test','',2,'2014-11-14 08:41:51','2014-11-14 08:41:51',55);"

    say 'Insert data for \'suite_maps\' table'
    @connection.execute "INSERT INTO `suite_maps` VALUES (31,43,55,'2014-11-14 08:41:51','2014-11-14 08:41:51',NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (287,43,339,NULL,NULL,0),(288,55,339,NULL,NULL,339),(289,55,220,NULL,NULL,340),(290,55,225,NULL,NULL,341),(291,55,226,NULL,NULL,342),(292,55,233,NULL,NULL,343),(293,55,234,NULL,NULL,344),(294,55,236,NULL,NULL,345),(295,55,237,NULL,NULL,346),(296,55,239,NULL,NULL,347),(297,55,240,NULL,NULL,348),(298,55,241,NULL,NULL,349),(299,55,244,NULL,NULL,350),(300,55,242,NULL,NULL,351),(301,55,243,NULL,NULL,352),(302,55,245,NULL,NULL,353);"
  end
end
