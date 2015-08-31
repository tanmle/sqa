class Sqaauto414AtgHolidayHardGoodsSmokeTestRemoveTc15AddressCheck < ActiveRecord::Migration
  def up
    say 'SQAAUTO-414 ATG - Holiday Hard Goods Smoke Test - remove tc15 address check'
    @connection = ActiveRecord::Base.connection

    say 'Update data on atg_pricetier table'
    @connection.execute 'delete from case_suite_maps where id = 292'
  end
end
