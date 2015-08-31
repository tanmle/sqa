class Sqaauto355CreateTestRunBrowserToReplaceFileBrowserWs < ActiveRecord::Migration
  def down
    update "update silos set `name` = 'Web soap services' where `name` = 'WS'"
  end

  def up
    say 'Seed changes in sql'
    say 'Update Silo Web service name from Web soap service to WS'

    update "update silos set `name` = 'WS' where `name` = 'Web soap services'"
  end
end
