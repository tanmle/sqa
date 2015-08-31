class Sqaauto837AtgContentCreateNewTestCaseToVerifyBaseAssets < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-837 ATG Content - create new test case to verify base assets'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (359,'Base assets checking','Verify Base assets','3_content/tc23_base_assets_checking.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (349,45,359,NULL,NULL,382);"
  end
end
