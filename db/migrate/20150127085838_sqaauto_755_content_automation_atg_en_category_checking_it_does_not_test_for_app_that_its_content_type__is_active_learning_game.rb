class Sqaauto755ContentAutomationAtgEnCategoryCheckingItDoesNotTestForAppThatItsContentTypeIsActiveLearningGame < ActiveRecord::Migration
  def up
    say 'SQAAUTO-755: CONTENT Automation: ATG EN: Category Checking: It does not test for app that its "Content Type" information is "Active Learning Game"'
    @connection = ActiveRecord::Base.connection

    say 'Update data on "atg_filter_list" table'
    @connection.execute "INSERT INTO `atg_filter_list` VALUES (619,'us','Active Learning Game','/en-us/app-center/c/_/N-1z141iw','Category'),(620,'ca','Active Learning Game','/en-ca/app-center/c/_/N-1z141iw','Category'),(621,'uk','Active Learning Game','/en-gb/app-centre/c/_/N-1z141iw','Category'),(622,'au','Active Learning Game','/en-au/app-centre/c/_/N-1z141iw','Category'),(623,'ie','Active Learning Game','/en-ie/app-centre/c/_/N-1z141iw','Category'),(624,'row','Active Learning Game','/en-oe/app-centre/c/_/N-1z141iw','Category');"
  end
end
