class Sqaauto378CreateAtgHolidayHardGoodsSmokeTestRemoveEmailTestCase < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection
    say 'SQAAUTO-378 [Sprint_3] Create ATG Holiday Hard Goods Smoke Test - update'

    say 'Remove email test case'
    @connection.execute 'delete from case_suite_maps where case_id = 234 and suite_id = 55'
  end
end
