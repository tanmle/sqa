class Sqaauto436StabilizeAtgHoliday2014HardGoodsSmokeTestRemoveNewRegistrationCase < ActiveRecord::Migration
  def up
    say 'SQAAUTO-436 - Stabilize ATG Holiday 2014 Hard Goods Smoke Test - remove new registration case'
    @connection = ActiveRecord::Base.connection

    say 'Remove the new registration test case from the suite'
    @connection.execute 'delete from case_suite_maps where id = 289'
  end
end
