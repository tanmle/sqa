class Sqaauto378CreateAtgHolidayHardGoodsSmokeTestUpdateAddress < ActiveRecord::Migration
  def up
    say 'SQAAUTO-378 [Sprint_3] Create ATG Holiday Hard Goods Smoke Test - update'
    
    say 'Update "1850 N Central Ave" to "117 W PALM LN" in "atg_address" table'
    AtgAddress.where(address1: '1850 N Central Ave').update_all(address1: '117 W PALM LN', postal: '85003-1126')
  end
end
