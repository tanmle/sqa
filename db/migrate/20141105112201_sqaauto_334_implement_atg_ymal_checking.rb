class Sqaauto334ImplementAtgYmalChecking < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-334 Implement atg_ymal_checking.rb'

    say 'Insert data for \'suites\' table'
    @connection.execute "INSERT INTO `suites` VALUES (52,'YMAL Checking','ATG YMAL Checking',2,NULL,NULL,52);"

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (335,'ATG Web You My Also Like checking','Check YMAL information on PDP page','9_atg_ymal_checking/tc01_atg_ymal_checking.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (283,52,335,NULL,NULL,335);"
  end
end
