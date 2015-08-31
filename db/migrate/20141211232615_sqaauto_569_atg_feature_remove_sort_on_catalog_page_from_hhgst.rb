class Sqaauto569AtgFeatureRemoveSortOnCatalogPageFromHhgst < ActiveRecord::Migration
  def up
    say 'SQAAUTO-569 [Sprint_4] ATG - feature - remove Sort on catalog page from HHGST'
    @connection = ActiveRecord::Base.connection

    @connection.execute 'delete from case_suite_maps where case_id = 242 and suite_id = 55'
  end
end
