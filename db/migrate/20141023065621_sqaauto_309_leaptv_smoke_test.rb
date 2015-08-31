class Sqaauto309LeaptvSmokeTest < ActiveRecord::Migration
  def up
    @connection = ActiveRecord::Base.connection

    say 'SQAAUTO-309 LeapTV Smoke Test: Tests basic features'

    say 'Insert data for \'cases\' table'
    @connection.execute "INSERT INTO `cases` VALUES (320,'LeapTV Smoke Test','Tests basic features: setup, web-registration','5_Glasgow/ts04_leaptv_smoke_test.rb',NULL,NULL);"

    say 'Insert data for \'case_suite_maps\' table'
    @connection.execute "INSERT INTO `case_suite_maps` VALUES (267,35,320,NULL,NULL,320);"
  end
end
