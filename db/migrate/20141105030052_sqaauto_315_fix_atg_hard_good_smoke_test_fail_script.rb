class Sqaauto315FixAtgHardGoodSmokeTestFailScript < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say "SQAAUTO-315 Fix ATG Hard Good Smoke Test test script"

    say 'Update testcase name for \'cases\' table'
    @connection.execute "UPDATE `cases` SET name='Add a bad address to account' WHERE script_path like '1_smoke_test/tc04_add_address_needs_to_be_checked.rb';"
    @connection.execute "UPDATE `cases` SET name='Search on Catalog page' WHERE script_path like '1_smoke_test/tc32_search_on_catalog_page.rb';"
  end
end
