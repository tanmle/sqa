class Sqaauto410AtgEnUpdateProcessAddTier6IntoAutomatedTestDatabase < ActiveRecord::Migration
  def up
    say 'SQAAUTO-410 CONTENT Automation: ATG EN: Update process: Please help us add Tier 6 - $30.00 into automated test database'
    @connection = ActiveRecord::Base.connection

    say 'Update data on atg_pricetier table'
    @connection.execute "INSERT INTO `atg_pricetier` VALUES (73,'us','Tier 6','30','$'),(74,'ca','Tier 6','35','$'),(75,'uk','Tier 6','25','£'),(76,'ie','Tier 6','30','€'),(77,'au','Tier 6','45','A$'),(78,'row','Tier 6','30','LF$');"
  end
end
