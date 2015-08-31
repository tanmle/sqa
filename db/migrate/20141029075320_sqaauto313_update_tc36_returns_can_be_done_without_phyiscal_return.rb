class Sqaauto313UpdateTc36ReturnsCanBeDoneWithoutPhyiscalReturn < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say "SQAAUTO-313 Update 'tc36_returns_can_be_done_without_phyiscal_return.rb'"

    say 'Update data for \'cases\' table'
    @connection.execute "UPDATE `cases` SET name='ATG Appeasement checking', script_path='1_smoke_test/tc36_appeasement_checking.rb' WHERE script_path like '%tc36_returns_can_be_done_without_a_physical_return.rb';"
  end
end
