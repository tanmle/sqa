class Sqaauto335ImplementAtgCaboYmalChecking < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-335 Implement atg_cabo_ymal_checking.rb'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (336,'ATG Cabo You My Also Like checking','CABO - Check YMAL information on PDP page','9_atg_ymal_checking/tc02_atg_cabo_ymal_checking.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (284,52,336,NULL,NULL,336);"
  end
end
