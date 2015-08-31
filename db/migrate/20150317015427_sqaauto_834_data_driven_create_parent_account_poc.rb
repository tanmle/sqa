class Sqaauto834DataDrivenCreateParentAccountPoc < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-834 [Q1_S8] Data-Driven - Create LF parent account POC'

    @connection.execute "INSERT INTO `suites` VALUES (60,'Data-Driven Tests','Data-Driven Tests',2,'2015-03-17 19:45:51','2015-03-17 19:45:51',60);"
    @connection.execute "INSERT INTO `cases` VALUES (360,'Create parent account','Create parent account with Data driven','10_data_driven_test/create_parent_account.rb',NULL,NULL);"
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (350,60,360,NULL,NULL,383);"
  end
end
