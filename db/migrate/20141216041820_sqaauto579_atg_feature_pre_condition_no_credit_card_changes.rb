class Sqaauto579AtgFeaturePreConditionNoCreditCardChanges < ActiveRecord::Migration
  def up
    say 'SQAAUTO-579 [Sprint_4] ATG - feature - Pre_Condition no CC changes'
    @connection = ActiveRecord::Base.connection

    say "Update: Test cases name in 'cases' table"
    @connection.execute "update cases set name = 'Pre_Condition (No Credit Card)', description = 'Hard Goods Pre-Condition (No Credit Card)' where script_path = '1_smoke_test/pre_condition_no_credit_card.rb';"
    @connection.execute "update cases set name = 'Pre_Condition (No Credit Card)', description = 'Soft Goods Pre-Condition (No Credit Card)' where script_path = '6_soft_good_smoke_test/soft_good_pre_condition_no_credit_card.rb';"
    @connection.execute "update cases set name = 'Pre_Condition', description = 'Soft Goods Pre-Condition' where script_path = '6_soft_good_smoke_test/soft_good_pre_condition.rb';"

    say "Delete: Hard Goods Pre_Condition (No Credit Card) from Hard Good Smoke test suite in 'case_suit_maps' table"
    @connection.execute "delete from case_suite_maps where suite_id = 43 and case_id = 339"
  end
end
