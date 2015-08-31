class Sqaauto948TcSiloCreateHardcodedBrowserTests < ActiveRecord::Migration
  def up
    say 'SQAAUTO-948 [Q1_S9] TC Silo - Create hardcoded browser tests'

    @connection = ActiveRecord::Base.connection
    @connection.execute "INSERT INTO `cases` VALUES (361,'Test browser Chrome','Test browser Chrome','configurations/test_browser_chrome.rb',NULL,NULL),(362,'Test browser Firefox','Test browser Firefox','configurations/test_browser_firefox.rb',NULL,NULL),(363,'Test browser IE','Test browser IE','configurations/test_browser_ie.rb',NULL,NULL),(364,'Test browser Webkit','Test browser Webkit','configurations/test_browser_webkit.rb',NULL,NULL);"
    @connection.execute "INSERT INTO `suites` VALUES (61,'Configuration','TC Configuration',4,NULL,NULL,61);"
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (351,61,361,NULL,NULL,384),(352,61,362,NULL,NULL,385),(353,61,363,NULL,NULL,386),(354,61,364,NULL,NULL,387);"
  end
end
